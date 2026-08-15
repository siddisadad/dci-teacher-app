import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d_c_i_teacher_app/features/daily_report/application/daily_report_notifier.dart';
import 'package:d_c_i_teacher_app/backend/repositories/daily_report_repository.dart';
import 'package:d_c_i_teacher_app/backend/repositories/student_repository.dart';
import 'package:d_c_i_teacher_app/backend/repositories/user_repository.dart';
import 'package:d_c_i_teacher_app/backend/providers/repository_providers.dart';
import 'package:d_c_i_teacher_app/backend/models/daily_report.dart';

class MockDailyReportRepository extends Mock implements DailyReportRepository {}

class MockStudentRepository extends Mock implements StudentRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockDailyReportRepository mockReportRepo;
  late MockStudentRepository mockStudentRepo;
  late MockUserRepository mockUserRepo;
  late ProviderContainer container;

  setUp(() {
    mockReportRepo = MockDailyReportRepository();
    mockStudentRepo = MockStudentRepository();
    mockUserRepo = MockUserRepository();

    container = ProviderContainer(
      overrides: [
        dailyReportRepositoryProvider.overrideWithValue(mockReportRepo),
        studentRepositoryProvider.overrideWithValue(mockStudentRepo),
        userRepositoryProvider.overrideWithValue(mockUserRepo),
      ],
    );

    registerFallbackValue(DailyReport(
      id: '',
      className: '',
      subject: '',
      teacher: '',
      chapter: '',
      topics: '',
      presentCount: 0,
      absentCount: 0,
      homeworkAssigned: '',
      remarks: '',
      createdBy: '',
      createdByEmail: '',
    ));
  });

  tearDown(() {
    container.dispose();
  });

  test('applyLastReport updates form values from last report', () async {
    final lastReport = DailyReport(
      id: 'old',
      className: 'Class 10',
      subject: 'Math',
      teacher: 'John Doe',
      chapter: 'Algebra',
      topics: 'Linear Equations',
      presentCount: 25,
      absentCount: 5,
      homeworkAssigned: 'Exercise 1.1',
      remarks: 'Good progress',
      createdBy: 'u1',
      createdByEmail: 'j@dci.com',
    );

    when(() => mockReportRepo.getLastReport())
        .thenAnswer((_) async => lastReport);
    when(() => mockUserRepo.getTeachers()).thenAnswer((_) async => []);
    when(() => mockUserRepo.getUserStream())
        .thenAnswer((_) => Stream.value(null));
    when(() => mockStudentRepo.getAllStudentsStream())
        .thenAnswer((_) => Stream.value([]));
    when(() => mockUserRepo.getAllUserSubjects()).thenAnswer((_) async => []);

    final notifier = container.read(dailyReportNotifierProvider.notifier);
    await container.read(dailyReportNotifierProvider.future);

    notifier.applyLastReport();

    final state = container.read(dailyReportNotifierProvider).value!;
    expect(state.selectedClass, 'Class 10');
    expect(state.selectedSubject, 'Math');
    expect(state.selectedTeacher, 'John Doe');
    expect(state.presentCount, 25);
    expect(state.absentCount, 5);
  });

  test('setCounts updates present and absent values', () async {
    when(() => mockUserRepo.getTeachers()).thenAnswer((_) async => []);
    when(() => mockUserRepo.getUserStream())
        .thenAnswer((_) => Stream.value(null));
    when(() => mockStudentRepo.getAllStudentsStream())
        .thenAnswer((_) => Stream.value([]));
    when(() => mockUserRepo.getAllUserSubjects()).thenAnswer((_) async => []);
    when(() => mockReportRepo.getLastReport()).thenAnswer((_) async => null);

    final notifier = container.read(dailyReportNotifierProvider.notifier);
    await container.read(dailyReportNotifierProvider.future);

    notifier.setPresentCount(30);
    notifier.setAbsentCount(2);

    final state = container.read(dailyReportNotifierProvider).value!;
    expect(state.presentCount, 30);
    expect(state.absentCount, 2);
  });
}
