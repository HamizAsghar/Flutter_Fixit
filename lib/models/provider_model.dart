class ProviderModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewsCount;
  final double hourlyRate;
  final String bio;

  ProviderModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewsCount,
    required this.hourlyRate,
    required this.bio,
  });
}

// Mock providers
final List<ProviderModel> mockProviders = [
  ProviderModel(
    id: 'p1',
    name: 'Ahmed Khan',
    category: 'Plumbing',
    imageUrl: 'https://api.dicebear.com/7.x/lorelei/png?seed=Ahmed',
    rating: 4.8,
    reviewsCount: 124,
    hourlyRate: 25.0,
    bio: 'Experienced plumber with over 10 years in the industry.',
  ),
  ProviderModel(
    id: 'p2',
    name: 'Saira Ali',
    category: 'Cleaning',
    imageUrl: 'https://api.dicebear.com/7.x/lorelei/png?seed=Saira',
    rating: 4.9,
    reviewsCount: 89,
    hourlyRate: 15.0,
    bio: 'Professional home cleaning services with attention to detail.',
  ),
  ProviderModel(
    id: 'p3',
    name: 'Zaid Sheikh',
    category: 'Electrician',
    imageUrl: 'https://api.dicebear.com/7.x/lorelei/png?seed=Zaid',
    rating: 4.7,
    reviewsCount: 56,
    hourlyRate: 30.0,
    bio: 'Certified electrician specializing in residential repairs.',
  ),
];
