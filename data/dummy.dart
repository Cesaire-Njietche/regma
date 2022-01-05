import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/media.dart';
import '../models/subscription.dart';

class Dummy {
  static var lessonItems = <LessonModel>[
    LessonModel(
      lessonID: 'l1',
      courseID: 'c1',
      content: 'ABC1',
      name: 'First Mystery',
      videoURL: '...',
    ),
    LessonModel(
      lessonID: 'l2',
      courseID: 'c1',
      content: 'ABC2',
      name: 'Second Mystery',
      videoURL: '...',
    ),
    LessonModel(
      lessonID: 'l3',
      courseID: 'c1',
      content: 'ABC3',
      name: 'Third Mystery',
      videoURL: '...',
    ),
    LessonModel(
      lessonID: 'l4',
      courseID: 'c1',
      content: 'ABC4',
      name: 'Fourth Mystery',
      videoURL: '...',
    ),
    LessonModel(
      lessonID: 'l5',
      courseID: 'c1',
      content: 'ABC5',
      name: 'Fifth Mystery',
      videoURL: '...',
    ),
    LessonModel(
      lessonID: 'l6',
      courseID: 'c1',
      content: 'ABC6',
      name: 'Sixth Mystery',
      videoURL: '...',
    ),
    LessonModel(
      lessonID: 'l7',
      courseID: 'c1',
      content: 'ABC7',
      name: 'Seventh Mystery',
      videoURL: '...',
    ),
    LessonModel(
      lessonID: 'l8',
      courseID: 'c1',
      content: 'ABC8',
      name: 'Eighth Mystery',
      videoURL: '...',
    ),
    LessonModel(
      lessonID: 'l9',
      courseID: 'c1',
      content: 'ABC9',
      name: 'Ninth Mystery',
      videoURL: '...',
    ),
    LessonModel(
      lessonID: 'l10',
      courseID: 'c1',
      content: 'ABC10',
      name: 'Tenth Mystery',
      videoURL: '...',
    ),
  ];

  static List<CourseModel> courseItems = <CourseModel>[
    CourseModel(
      courseID: 'c1',
      name: 'Food Mastery',
      description: 'Learn to dish the best foods in the world',
      monthlyPrice: 20.0,
      yearlyPrice: 210,
      minUserAge: 6,
      maxUserAge: 8,
      isLock: true,
      thumbnailURL:
          'https://digitaldefynd.com/wp-content/uploads/2020/06/Best-Food-Management-course-tutorial-class-certification-training-online-1024x683.jpg',
    ),
    CourseModel(
      courseID: 'c2',
      name: 'Photography Legend',
      description: 'Become a master in taking picture',
      yearlyPrice: 600,
      monthlyPrice: 56.99,
      minUserAge: 9,
      maxUserAge: 10,
      isLock: false,
      thumbnailURL:
          'https://onlinecourses.one/wp-content/uploads/2019/08/best-photography-course-tutorial-class-certification-training-online.jpg',
    ),
    CourseModel(
      courseID: 'c3',
      name: 'Coding BootCamp',
      description: 'Learn to code as ABC and become a master coder',
      monthlyPrice: 99.99,
      yearlyPrice: 1100,
      minUserAge: 12,
      maxUserAge: 14,
      isLock: false,
      thumbnailURL:
          'https://media.salon.com/2019/05/sale_19347_primary_image.jpg',
    ),
    CourseModel(
      courseID: 'c4',
      name: 'Drone Class',
      description: 'Leverage the power of drones in your daily activities',
      monthlyPrice: 129.99,
      yearlyPrice: 1500,
      minUserAge: 15,
      maxUserAge: 16,
      isLock: false,
      thumbnailURL:
          'https://digitaldefynd.com/wp-content/uploads/2020/07/Best-Drone-course-tutorial-class-certification-training-online-scaled.jpg',
    ),
    CourseModel(
      courseID: 'c5',
      name: 'Music Sessions',
      description:
          'Music heals the world. Be part of the healers and make the world a better place',
      monthlyPrice: 9.99,
      yearlyPrice: 120,
      minUserAge: 17,
      maxUserAge: 18,
      isLock: false,
      thumbnailURL:
          'https://www.musictech.net/wp-content/uploads/2019/02/pro-tips-hub-cover-header@1400x1050.jpg',
    ),
  ];

  static var media = <Media>[
    Media(
      id: 'b1',
      title: 'Business Adventures',
      description: 'Go for it',
      contentUrl: 'contentUrl',
      imageUrl:
          'https://i.insider.com/5df14aacfd9db226e74356c2?width=1000&format=jpeg&auto=webp',
      type: 'Book',
      isFree: true,
      author: 'John Brooks',
      length: 0,
    ),
    Media(
      id: 'b2',
      title: 'The Intelligent Investor',
      description: 'Tips and tricks on investing your money in the modern era',
      contentUrl: 'contentUrl',
      imageUrl:
          'https://i.insider.com/5df14adffd9db2138f2ec575?width=750&format=jpeg&auto=webp',
      type: 'Book',
      isFree: true,
      author: 'Benjamin Graham',
      length: 0,
    ),
    Media(
      id: 'b3',
      title: 'Crossing the Chasm',
      description: 'The art of selling anything to anyone',
      contentUrl: 'contentUrl',
      imageUrl:
          'https://hacktheentrepreneur.com/wp-content/uploads/2018/09/Crossing-the-Chasm.jpg',
      type: 'Book',
      isFree: false,
      author: 'Geoffrey A. Moore',
      price: 23,
      length: 0,
    ),
    Media(
      id: 'b4',
      title: 'Start Your Own Business',
      description: 'Be your own boss and Manage your time as per your desire',
      contentUrl: 'contentUrl',
      imageUrl:
          'https://images-na.ssl-images-amazon.com/images/I/51gHiS5TjtL._SX333_BO1,204,203,200_.jpg',
      type: 'Book',
      isFree: false,
      author: 'Rieva Lesonsky',
      price: 41.66,
      length: 0,
    ),
    Media(
      id: 'v1',
      title: 'Trust God',
      description: 'Trust God when life is hard',
      contentUrl: 'contentUrl',
      imageUrl: 'https://i.ytimg.com/vi/WK1eRHhS0D0/maxresdefault.jpg',
      type: 'Movie',
      isFree: true,
      author: 'The Faith Group',
      length: 9,
    ),
    Media(
      id: 'v2',
      title: 'Pursuing Jesus',
      description: 'Pursue the path of truth and genuine freedom',
      contentUrl: 'contentUrl',
      imageUrl: 'https://i.ytimg.com/vi/AGWrM8_9T-w/maxresdefault.jpg',
      type: 'Movie',
      isFree: true,
      author: 'Troy Black',
      length: 5,
    ),
    Media(
      id: 'v3',
      title: 'God First',
      description: 'Put god first in any of your endeavour',
      contentUrl: 'contentUrl',
      imageUrl:
          'https://i.pinimg.com/236x/e6/3b/44/e63b446cb27d89543d990c80a0b78b8e.jpg',
      type: 'Movie',
      isFree: false,
      author: 'The Faith Group',
      price: 56,
      length: 6,
    ),
    Media(
        id: 'v4',
        title: 'When God Says No',
        description: 'God has a plan for all of us. Trust the process',
        contentUrl: 'contentUrl',
        imageUrl:
            'https://i.pinimg.com/originals/01/03/3b/01033b908f9a5d6e1e4ee662c718567c.jpg',
        type: 'Movie',
        isFree: true,
        author: 'Inky Johnson',
        length: 3),
    Media(
      id: 'm1',
      title: 'When God Says No',
      description: 'God has a plan for all of us. Trust the process',
      contentUrl: 'contentUrl',
      imageUrl:
          'https://i.pinimg.com/originals/01/03/3b/01033b908f9a5d6e1e4ee662c718567c.jpg',
      type: 'Music',
      isFree: true,
      author: 'Inky Johnson',
      length: 3,
    ),
    Media(
      id: 'p1',
      title: 'When God Says No',
      description: 'God has a plan for all of us. Trust the process',
      contentUrl: 'contentUrl',
      imageUrl:
          'https://i.pinimg.com/originals/01/03/3b/01033b908f9a5d6e1e4ee662c718567c.jpg',
      type: 'Podcast',
      isFree: false,
      price: 58.78,
      author: 'Inky Johnson',
      length: 3,
    ),
    Media(
      id: 'e1',
      title: 'When God Says No',
      description: 'God has a plan for all of us. Trust the process',
      contentUrl: 'contentUrl',
      imageUrl:
          'https://i.pinimg.com/originals/01/03/3b/01033b908f9a5d6e1e4ee662c718567c.jpg',
      type: 'Event',
      isFree: true,
      author: 'Inky Johnson',
      length: 3,
    ),
  ];

  static var subscriptions = <Subscription>[
    Subscription(
      id: 's1',
      userId: 'userId',
      courseId: 'c2',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(
        Duration(days: 30),
      ),
      plan: Plan.Monthly,
    ),
    Subscription(
      id: 's2',
      userId: 'userId',
      courseId: 'c4',
      startDate: DateTime.now().subtract(
        Duration(days: 7),
      ),
      endDate: null,
      plan: Plan.Yearly,
    ),
  ];
}
