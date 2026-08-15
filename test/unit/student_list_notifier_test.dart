import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d_c_i_teacher_app/features/student/application/student_list_notifier.dart';
import 'package:d_c_i_teacher_app/backend/models/student.dart';
import 'package:d_c_i_teacher_app/backend/providers/repository_providers.dart';

void main() {
  late ProviderContainer container;
  final mockStudents = [
    Student(id: '1', name: 'John Doe', studentId: 'S1', rollNo: '101', className: '10-A'),
    Student(id: '2', name: 'Jane Smith', studentId: 'S2', rollNo: '102', className: '10-B'),
    Student(id: '3', name: 'Bob Wilson', studentId: 'S3', rollNo: '103', className: '10-A'),
  ];

  setUp(() {
    container = ProviderContainer(
      overrides: [
        studentsStreamProvider.overrideWith((ref) => Stream.value(mockStudents)),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('filteredStudentsProvider initial state matches all students', () {
    final state = container.read(filteredStudentsProvider);
    expect(state.value, mockStudents);
  });

  test('updateSearchQuery filters students by name', () async {
    final notifier = container.read(studentListNotifierProvider.notifier);

    notifier.updateSearchQuery('Jane');
    
    // We need to wait for the debounce logic in debouncedStudentSearchQueryProvider
    await Future.delayed(const Duration(milliseconds: 400));
    
    final filtered = container.read(filteredStudentsProvider).value!;
    expect(filtered.length, 1);
    expect(filtered.first.name, 'Jane Smith');
  });

  test('updateClassFilter filters students by class', () {
    final notifier = container.read(studentListNotifierProvider.notifier);

    notifier.updateClassFilter('10-A');
    
    final filtered = container.read(filteredStudentsProvider).value!;
    expect(filtered.length, 2);
    expect(filtered.every((s) => s.className == '10-A'), isTrue);

    notifier.updateClassFilter('All Classes');
    final allFiltered = container.read(filteredStudentsProvider).value!;
    expect(allFiltered.length, 3);
  });

  test('Combined filters (search + class) work correctly', () async {
    final notifier = container.read(studentListNotifierProvider.notifier);

    notifier.updateClassFilter('10-A');
    notifier.updateSearchQuery('Bob');
    
    await Future.delayed(const Duration(milliseconds: 400));

    final filtered = container.read(filteredStudentsProvider).value!;
    expect(filtered.length, 1);
    expect(filtered.first.name, 'Bob Wilson');
  });

  test('clearFilters resets search and class filter', () async {
    final notifier = container.read(studentListNotifierProvider.notifier);

    notifier.updateClassFilter('10-B');
    notifier.updateSearchQuery('Jane');

    await Future.delayed(const Duration(milliseconds: 400));

    notifier.clearFilters();
    
    await Future.delayed(const Duration(milliseconds: 400));

    final filtered = container.read(filteredStudentsProvider).value!;
    expect(filtered.length, 3);
  });
}
