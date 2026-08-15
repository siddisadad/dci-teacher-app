import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d_c_i_teacher_app/features/student/application/student_list_notifier.dart';
import 'package:d_c_i_teacher_app/backend/models/student.dart';
import 'package:d_c_i_teacher_app/backend/providers/repository_providers.dart';

void main() {
  late ProviderContainer container;
  final mockStudents = [
    Student(
        id: '1',
        name: 'John Doe',
        studentId: 'S1',
        rollNo: '101',
        className: 'Class 10'),
    Student(
        id: '2',
        name: 'Jane Smith',
        studentId: 'S2',
        rollNo: '102',
        className: 'Class 11'),
    Student(
        id: '3',
        name: 'Bob Wilson',
        studentId: 'S3',
        rollNo: '103',
        className: 'Class 10'),
  ];

  setUp(() {
    container = ProviderContainer(
      overrides: [
        studentsStreamProvider
            .overrideWith((ref) => Stream.value(mockStudents)),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('filteredStudentsProvider initial state matches all students', () async {
    await container.read(studentsStreamProvider.future);
    final state = container.read(filteredStudentsProvider);
    expect(state.value, mockStudents);
  });

  test('updateSearchQuery filters students by name', () async {
    await container.read(studentsStreamProvider.future);
    container.read(filteredStudentsProvider);
    final notifier = container.read(studentListNotifierProvider.notifier);

    notifier.updateSearchQuery('Jane');

    // We need to wait for the debounce logic in debouncedStudentSearchQueryProvider
    await Future.delayed(const Duration(milliseconds: 400));

    final filtered = container.read(filteredStudentsProvider).value!;
    expect(filtered.length, 1);
    expect(filtered.first.name, 'Jane Smith');
  });

  test('updateClassFilter filters students by class', () async {
    await container.read(studentsStreamProvider.future);
    final notifier = container.read(studentListNotifierProvider.notifier);

    notifier.updateClassFilter('Class 10');

    final filtered = container.read(filteredStudentsProvider).value!;
    expect(filtered.length, 2);
    expect(filtered.every((s) => s.className == 'Class 10'), isTrue);

    notifier.updateClassFilter('All Classes');
    final allFiltered = container.read(filteredStudentsProvider).value!;
    expect(allFiltered.length, 3);
  });

  test('Combined filters (search + class) work correctly', () async {
    await container.read(studentsStreamProvider.future);
    final notifier = container.read(studentListNotifierProvider.notifier);

    container.read(filteredStudentsProvider);
    notifier.updateClassFilter('Class 10');
    notifier.updateSearchQuery('Bob');

    await Future.delayed(const Duration(milliseconds: 400));

    final filtered = container.read(filteredStudentsProvider).value!;
    expect(filtered.length, 1);
    expect(filtered.first.name, 'Bob Wilson');
  });

  test('clearFilters resets search and class filter', () async {
    await container.read(studentsStreamProvider.future);
    final notifier = container.read(studentListNotifierProvider.notifier);

    container.read(filteredStudentsProvider);
    notifier.updateClassFilter('Class 11');
    notifier.updateSearchQuery('Jane');

    await Future.delayed(const Duration(milliseconds: 400));

    notifier.clearFilters();

    await Future.delayed(const Duration(milliseconds: 400));

    final filtered = container.read(filteredStudentsProvider).value!;
    expect(filtered.length, 3);
  });
}
