import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final String imageUrl;
  final List<SubServiceCategory> subCategories;

  CategoryModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.imageUrl,
    this.subCategories = const [],
  });
}

class SubServiceCategory {
  final String id;
  final String title;
  final IconData icon;
  final List<ServiceVariant> variants;

  SubServiceCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.variants,
  });
}

class ServiceVariant {
  final String id;
  final String title;
  final String price;
  final String imageUrl;

  ServiceVariant({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });
}

// Minimal stable mock categories to verify flow fix
final List<CategoryModel> mockCategories = [
  CategoryModel(
    id: '1',
    title: 'Plumbing',
    icon: Icons.plumbing,
    color: Colors.blue,
    imageUrl: 'assets/images/onboarding_2.png',
    subCategories: [
      SubServiceCategory(
        id: 'p1',
        title: 'Fix leaking taps',
        icon: Icons.water_drop,
        variants: [
          ServiceVariant(
            id: 'pv1',
            title: 'Tap Repair',
            price: 'Rs. 20',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'p2',
        title: 'Pipe installation',
        icon: Icons.reorder,
        variants: [
          ServiceVariant(
            id: 'pv2',
            title: 'Pipe Work',
            price: 'Rs. 80',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'p3',
        title: 'Bathroom fittings',
        icon: Icons.bathtub,
        variants: [
          ServiceVariant(
            id: 'pv3',
            title: 'Fitting Fix',
            price: 'Rs. 45',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'p4',
        title: 'Drain unclogging',
        icon: Icons.waves,
        variants: [
          ServiceVariant(
            id: 'pv4',
            title: 'Drain Cleaning',
            price: 'Rs. 35',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
    ],
  ),
  CategoryModel(
    id: '2',
    title: 'Electrical / Gas Repair',
    icon: Icons.electrical_services,
    color: Colors.orange,
    imageUrl: 'assets/images/onboarding_2.png',
    subCategories: [
      SubServiceCategory(
        id: 'e1',
        title: 'Wiring & connections',
        icon: Icons.bolt,
        variants: [
          ServiceVariant(
            id: 'ev1',
            title: 'Wiring Fix',
            price: 'Rs. 50',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'e2',
        title: 'Appliance repair',
        icon: Icons.kitchen,
        variants: [
          ServiceVariant(
            id: 'ev2',
            title: 'Fridge/AC Fix',
            price: 'Rs. 70',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'e3',
        title: 'Gas line repair',
        icon: Icons.local_fire_department,
        variants: [
          ServiceVariant(
            id: 'ev3',
            title: 'Gas Work',
            price: 'Rs. 90',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'e4',
        title: 'Light fixtures',
        icon: Icons.lightbulb,
        variants: [
          ServiceVariant(
            id: 'ev4',
            title: 'Light Install',
            price: 'Rs. 30',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
    ],
  ),
  CategoryModel(
    id: '3',
    title: 'Cleaning & Housekeeping',
    icon: Icons.cleaning_services,
    color: Colors.green,
    imageUrl: 'assets/images/onboarding_2.png',
    subCategories: [
      SubServiceCategory(
        id: 'c1',
        title: 'Full home cleaning',
        icon: Icons.home_work,
        variants: [
          ServiceVariant(
            id: 'cv1',
            title: 'Deep Cleaning',
            price: 'Rs. 120',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'c2',
        title: 'Carpet cleaning',
        icon: Icons.grid_view,
        variants: [
          ServiceVariant(
            id: 'cv2',
            title: 'Carpet Wash',
            price: 'Rs. 40',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'c3',
        title: 'Dusting & organizing',
        icon: Icons.auto_awesome_motion,
        variants: [
          ServiceVariant(
            id: 'cv3',
            title: 'Organizing',
            price: 'Rs. 30',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'c4',
        title: 'Deep area cleaning',
        icon: Icons.sanitizer,
        variants: [
          ServiceVariant(
            id: 'cv4',
            title: 'Area Deep Clean',
            price: 'Rs. 60',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
    ],
  ),
  CategoryModel(
    id: '4',
    title: 'Gardening & Landscaping',
    icon: Icons.grass,
    color: Colors.teal,
    imageUrl: 'assets/images/onboarding_2.png',
    subCategories: [
      SubServiceCategory(
        id: 'g1',
        title: 'Lawn mowing',
        icon: Icons.agriculture,
        variants: [
          ServiceVariant(
            id: 'gv1',
            title: 'Lawn Care',
            price: 'Rs. 25',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'g2',
        title: 'Plant watering',
        icon: Icons.opacity,
        variants: [
          ServiceVariant(
            id: 'gv2',
            title: 'Plant Care',
            price: 'Rs. 20',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'g3',
        title: 'Garden design',
        icon: Icons.yard,
        variants: [
          ServiceVariant(
            id: 'gv3',
            title: 'Landscaping',
            price: 'Rs. 200',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'g4',
        title: 'Tree pruning',
        icon: Icons.nature_people,
        variants: [
          ServiceVariant(
            id: 'gv4',
            title: 'Tree Care',
            price: 'Rs. 50',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
    ],
  ),
  CategoryModel(
    id: '5',
    title: 'Tailoring / Laundry',
    icon: Icons.dry_cleaning,
    color: Colors.purple,
    imageUrl: 'assets/images/onboarding_2.png',
    subCategories: [
      SubServiceCategory(
        id: 't1',
        title: 'Clothing repair',
        icon: Icons.content_cut,
        variants: [
          ServiceVariant(
            id: 'tv1',
            title: 'Alteration',
            price: 'Rs. 15',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 't2',
        title: 'Stitching',
        icon: Icons.checkroom,
        variants: [
          ServiceVariant(
            id: 'tv2',
            title: 'New Stitching',
            price: 'Rs. 40',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 't3',
        title: 'Dry cleaning',
        icon: Icons.local_laundry_service,
        variants: [
          ServiceVariant(
            id: 'tv3',
            title: 'Dry Wash',
            price: 'Rs. 20',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 't4',
        title: 'Ironing services',
        icon: Icons.iron,
        variants: [
          ServiceVariant(
            id: 'tv4',
            title: 'Ironing',
            price: 'Rs. 5',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
    ],
  ),
  CategoryModel(
    id: '6',
    title: 'Vehicle / Auto Repair',
    icon: Icons.directions_car,
    color: Colors.indigo,
    imageUrl: 'assets/images/onboarding_2.png',
    subCategories: [
      SubServiceCategory(
        id: 'v1',
        title: 'Car servicing',
        icon: Icons.settings_suggest,
        variants: [
          ServiceVariant(
            id: 'vv1',
            title: 'Full Service',
            price: 'Rs. 80',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'v2',
        title: 'Tire repair',
        icon: Icons.adjust,
        variants: [
          ServiceVariant(
            id: 'vv2',
            title: 'Tire Work',
            price: 'Rs. 30',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'v3',
        title: 'Engine checkup',
        icon: Icons.engineering,
        variants: [
          ServiceVariant(
            id: 'vv3',
            title: 'Engine Work',
            price: 'Rs. 150',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'v4',
        title: 'Oil change',
        icon: Icons.oil_barrel,
        variants: [
          ServiceVariant(
            id: 'vv4',
            title: 'Oil Change',
            price: 'Rs. 40',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
    ],
  ),
  CategoryModel(
    id: '7',
    title: 'Painting & Home Improvement',
    icon: Icons.format_paint,
    color: Colors.redAccent,
    imageUrl: 'assets/images/onboarding_2.png',
    subCategories: [
      SubServiceCategory(
        id: 'pa1',
        title: 'Wall painting',
        icon: Icons.brush,
        variants: [
          ServiceVariant(
            id: 'pav1',
            title: 'Painting',
            price: 'Rs. 300',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'pa2',
        title: 'Furniture repair',
        icon: Icons.chair,
        variants: [
          ServiceVariant(
            id: 'pav2',
            title: 'Furniture Work',
            price: 'Rs. 100',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'pa3',
        title: 'Minor carpentry',
        icon: Icons.square_foot,
        variants: [
          ServiceVariant(
            id: 'pav3',
            title: 'Carpentry',
            price: 'Rs. 50',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'pa4',
        title: 'Home decoration',
        icon: Icons.wallpaper,
        variants: [
          ServiceVariant(
            id: 'pav4',
            title: 'Decoration',
            price: 'Rs. 200',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
    ],
  ),
  CategoryModel(
    id: '8',
    title: 'Pest Control',
    icon: Icons.bug_report,
    color: Colors.brown,
    imageUrl: 'assets/images/onboarding_2.png',
    subCategories: [
      SubServiceCategory(
        id: 'pe1',
        title: 'Termite treatment',
        icon: Icons.pest_control_rodent,
        variants: [
          ServiceVariant(
            id: 'pev1',
            title: 'Termite Kill',
            price: 'Rs. 120',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'pe2',
        title: 'Insect control',
        icon: Icons.pest_control,
        variants: [
          ServiceVariant(
            id: 'pev2',
            title: 'Insect Spray',
            price: 'Rs. 40',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'pe3',
        title: 'Rodent extermination',
        icon: Icons.do_not_step,
        variants: [
          ServiceVariant(
            id: 'pev3',
            title: 'Rodent Kill',
            price: 'Rs. 60',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
      SubServiceCategory(
        id: 'pe4',
        title: 'Bed bug treatment',
        icon: Icons.coronavirus,
        variants: [
          ServiceVariant(
            id: 'pev4',
            title: 'Bug Kill',
            price: 'Rs. 80',
            imageUrl: 'assets/images/onboarding_2.png',
          ),
        ],
      ),
    ],
  ),
];
