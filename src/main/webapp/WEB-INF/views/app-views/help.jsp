<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Session Check -->
<c:if test="${empty sessionScope.loggedInStaff}">
    <c:redirect url="/login?status=sessionExpired"/>
</c:if>

<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help & User Guide — Ocean View Resort</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter', 'sans-serif'] },
                    colors: {
                        primary: {
                            50: '#f0f4ff',
                            100: '#e8f0fb',
                            500: '#1B4F8A',
                            600: '#163d6e',
                            700: '#0f2a4d'
                        }
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-950 text-gray-100">
    
    <div class="flex h-screen overflow-hidden">
        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/includes/sidebar.jsp">
            <jsp:param name="activePage" value="help" />
        </jsp:include>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col overflow-hidden">
            
            <!-- Header -->
            <header class="bg-gray-900 border-b border-gray-800 px-8 py-4">
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-4">
                        <a href="${pageContext.request.contextPath}/dashboard" 
                           class="text-gray-400 hover:text-white transition-colors">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                            </svg>
                        </a>
                        <div>
                            <h1 class="text-2xl font-bold text-white flex items-center">
                                <svg class="w-7 h-7 mr-3 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                </svg>
                                Help & User Guide
                            </h1>
                            <p class="text-sm text-gray-400 mt-1">Everything you need to know about using Ocean View Resort HMS</p>
                        </div>
                    </div>
                    <div class="flex items-center space-x-4">
                        <span class="text-sm text-gray-400">Welcome, <strong class="text-white">${sessionScope.staffName}</strong></span>
                    </div>
                </div>
            </header>

            <!-- Main Content Area -->
            <main class="flex-1 overflow-y-auto bg-gray-950 p-8">
                <div class="max-w-5xl mx-auto">
                    
                    <!-- Quick Search -->
                    <div class="mb-8">
                        <div class="relative">
                            <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                            </svg>
                            <input type="text" 
                                   id="helpSearch"
                                   placeholder="Search for help topics..."
                                   class="w-full bg-gray-900 border border-gray-700 text-gray-300 rounded-lg pl-12 pr-4 py-3 focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none">
                        </div>
                    </div>

                    <!-- Help Sections -->
                    <div class="space-y-6">
                        
                        <!-- 1. Getting Started -->
                        <div class="bg-gray-900 border border-gray-800 rounded-xl overflow-hidden">
                            <button onclick="toggleSection('getting-started')" 
                                    class="w-full px-6 py-4 flex items-center justify-between hover:bg-gray-800 transition-colors">
                                <div class="flex items-center">
                                    <span class="w-10 h-10 bg-primary-600 rounded-lg flex items-center justify-center mr-4">
                                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                                        </svg>
                                    </span>
                                    <div class="text-left">
                                        <h3 class="text-lg font-semibold text-white">Getting Started</h3>
                                        <p class="text-sm text-gray-400">First time using the system? Start here</p>
                                    </div>
                                </div>
                                <svg class="w-5 h-5 text-gray-400 transform transition-transform" id="icon-getting-started" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                                </svg>
                            </button>
                            
                            <div id="getting-started" class="hidden px-6 pb-6">
                                <div class="space-y-4 text-gray-300">
                                    <div class="bg-gray-800 rounded-lg p-4">
                                        <h4 class="font-semibold text-white mb-2">1. Login to the System</h4>
                                        <p class="text-sm">Use your staff credentials provided by the administrator to access the system. Navigate to the login page and enter your username and password.</p>
                                    </div>
                                    <div class="bg-gray-800 rounded-lg p-4">
                                        <h4 class="font-semibold text-white mb-2">2. Navigate the Dashboard</h4>
                                        <p class="text-sm">The dashboard shows today's revenue, occupancy rate, checked-in guests, and total guests at a glance. Use this as your starting point each day.</p>
                                    </div>
                                    <div class="bg-gray-800 rounded-lg p-4">
                                        <h4 class="font-semibold text-white mb-2">3. Explore the Menu</h4>
                                        <p class="text-sm">Use the sidebar to access different modules: Guests, Rooms, Room Types, Reservations, Payments, Seasonal Rates, and more.</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 2. Guest Management -->
                        <div class="bg-gray-900 border border-gray-800 rounded-xl overflow-hidden">
                            <button onclick="toggleSection('guest-mgmt')" 
                                    class="w-full px-6 py-4 flex items-center justify-between hover:bg-gray-800 transition-colors">
                                <div class="flex items-center">
                                    <span class="w-10 h-10 bg-green-600 rounded-lg flex items-center justify-center mr-4">
                                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                                        </svg>
                                    </span>
                                    <div class="text-left">
                                        <h3 class="text-lg font-semibold text-white">Guest Management</h3>
                                        <p class="text-sm text-gray-400">How to register and manage guests</p>
                                    </div>
                                </div>
                                <svg class="w-5 h-5 text-gray-400 transform transition-transform" id="icon-guest-mgmt" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                                </svg>
                            </button>
                            
                            <div id="guest-mgmt" class="hidden px-6 pb-6">
                                <div class="space-y-4 text-gray-300">
                                    <div class="bg-gray-800 rounded-lg p-4">
                                        <h4 class="font-semibold text-white mb-2">How to Add a New Guest</h4>
                                        <ol class="text-sm space-y-2 list-decimal list-inside ml-2">
                                            <li>Navigate to "Guests" in the sidebar</li>
                                            <li>Click "+ Add Guest" button at the top right</li>
                                            <li>Fill in required guest details (first name, last name, email, phone, address)</li>
                                            <li>Optionally add NIC/Passport, nationality, date of birth, and gender</li>
                                            <li>Select guest type (Regular, VIP, or Corporate)</li>
                                            <li>Click "Save Guest"</li>
                                            <li>System will auto-generate a unique guest code (e.g., G000001)</li>
                                        </ol>
                                    </div>
                                    <div class="bg-gray-800 rounded-lg p-4">
                                        <h4 class="font-semibold text-white mb-2">How to Search for a Guest</h4>
                                        <p class="text-sm">Use the search bar at the top of the guest list to find guests by name, email, phone, or guest code. Results update as you type.</p>
                                    </div>
                                    <div class="bg-gray-800 rounded-lg p-4">
                                        <h4 class="font-semibold text-white mb-2">Guest Status Options</h4>
                                        <ul class="text-sm space-y-1 ml-2">
                                            <li>• <strong class="text-yellow-400">VIP:</strong> Premium guests with special privileges</li>
                                            <li>• <strong class="text-blue-400">Corporate:</strong> Business/company guests</li>
                                            <li>• <strong class="text-red-400">Blacklisted:</strong> Guests restricted from booking</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 3. Reservation Process -->
                        <div class="bg-gray-900 border border-gray-800 rounded-xl overflow-hidden">
                            <button onclick="toggleSection('reservation')" 
                                    class="w-full px-6 py-4 flex items-center justify-between hover:bg-gray-800 transition-colors">
                                <div class="flex items-center">
                                    <span class="w-10 h-10 bg-purple-600 rounded-lg flex items-center justify-center mr-4">
                                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                                        </svg>
                                    </span>
                                    <div class="text-left">
                                        <h3 class="text-lg font-semibold text-white">Reservation Process</h3>
                                        <p class="text-sm text-gray-400">Complete booking workflow explained</p>
                                    </div>
                                </div>
                                <svg class="w-5 h-5 text-gray-400 transform transition-transform" id="icon-reservation" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                                </svg>
                            </button>
                            
                            <div id="reservation" class="hidden px-6 pb-6">
                                <div class="space-y-4 text-gray-300">
                                    <div class="bg-gradient-to-r from-purple-600/20 to-blue-600/20 border border-purple-500/30 rounded-lg p-4">
                                        <h4 class="font-semibold text-white mb-3">📋 Complete Workflow:</h4>
                                        <div class="space-y-3">
                                            <div class="flex items-start">
                                                <span class="bg-purple-600 text-white text-xs font-bold rounded-full w-6 h-6 flex items-center justify-center mr-3 mt-0.5 flex-shrink-0">1</span>
                                                <div>
                                                    <p class="font-medium text-white">Create Reservation</p>
                                                    <p class="text-sm text-gray-300">Select guest, room, check-in/check-out dates → System automatically calculates total amount using seasonal rates (if applicable) or base room price</p>
                                                </div>
                                            </div>
                                            <div class="flex items-start">
                                                <span class="bg-purple-600 text-white text-xs font-bold rounded-full w-6 h-6 flex items-center justify-center mr-3 mt-0.5 flex-shrink-0">2</span>
                                                <div>
                                                    <p class="font-medium text-white">Guest Arrives (Check-In)</p>
                                                    <p class="text-sm text-gray-300">On check-in date, change reservation status to "Checked In" → Room status automatically updates to "Occupied" → Actual check-in time is recorded</p>
                                                </div>
                                            </div>
                                            <div class="flex items-start">
                                                <span class="bg-purple-600 text-white text-xs font-bold rounded-full w-6 h-6 flex items-center justify-center mr-3 mt-0.5 flex-shrink-0">3</span>
                                                <div>
                                                    <p class="font-medium text-white">During Stay</p>
                                                    <p class="text-sm text-gray-300">Add extra charges as needed (room service, spa treatments, laundry, excursions) → These are automatically added to the final bill</p>
                                                </div>
                                            </div>
                                            <div class="flex items-start">
                                                <span class="bg-purple-600 text-white text-xs font-bold rounded-full w-6 h-6 flex items-center justify-center mr-3 mt-0.5 flex-shrink-0">4</span>
                                                <div>
                                                    <p class="font-medium text-white">Check-Out & Payment</p>
                                                    <p class="text-sm text-gray-300">Calculate final bill (room charges + extras + tax) → Record payment → Update status to "Checked Out" → Room becomes "Available" again</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 4. Room Management -->
                        <div class="bg-gray-900 border border-gray-800 rounded-xl overflow-hidden">
                            <button onclick="toggleSection('room-mgmt')" 
                                    class="w-full px-6 py-4 flex items-center justify-between hover:bg-gray-800 transition-colors">
                                <div class="flex items-center">
                                    <span class="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center mr-4">
                                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
                                        </svg>
                                    </span>
                                    <div class="text-left">
                                        <h3 class="text-lg font-semibold text-white">Room Management</h3>
                                        <p class="text-sm text-gray-400">Managing rooms and room types</p>
                                    </div>
                                </div>
                                <svg class="w-5 h-5 text-gray-400 transform transition-transform" id="icon-room-mgmt" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                                </svg>
                            </button>
                            
                            <div id="room-mgmt" class="hidden px-6 pb-6">
                                <div class="space-y-4 text-gray-300">
                                    <div class="bg-gray-800 rounded-lg p-4">
                                        <h4 class="font-semibold text-white mb-2">Room Status Types</h4>
                                        <ul class="text-sm space-y-2 ml-2">
                                            <li>• <strong class="text-green-400">Available:</strong> Room is ready for new bookings</li>
                                            <li>• <strong class="text-red-400">Occupied:</strong> Guest is currently staying</li>
                                            <li>• <strong class="text-yellow-400">Maintenance:</strong> Room is being serviced/repaired</li>
                                            <li>• <strong class="text-blue-400">Reserved:</strong> Booked but guest hasn't checked in yet</li>
                                        </ul>
                                    </div>
                                    <div class="bg-gray-800 rounded-lg p-4">
                                        <h4 class="font-semibold text-white mb-2">How to Add a New Room</h4>
                                        <ol class="text-sm space-y-2 list-decimal list-inside ml-2">
                                            <li>Navigate to "Rooms" in the sidebar</li>
                                            <li>Click "+ Add Room"</li>
                                            <li>Enter room number and select room type</li>
                                            <li>Set floor number and view type (optional)</li>
                                            <li>Set initial status (usually "Available")</li>
                                            <li>Click "Save Room"</li>
                                        </ol>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 5. Seasonal Rates -->
                        <div class="bg-gray-900 border border-gray-800 rounded-xl overflow-hidden">
                            <button onclick="toggleSection('seasonal-rates')" 
                                    class="w-full px-6 py-4 flex items-center justify-between hover:bg-gray-800 transition-colors">
                                <div class="flex items-center">
                                    <span class="w-10 h-10 bg-orange-600 rounded-lg flex items-center justify-center mr-4">
                                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                        </svg>
                                    </span>
                                    <div class="text-left">
                                        <h3 class="text-lg font-semibold text-white">Seasonal Rates</h3>
                                        <p class="text-sm text-gray-400">Dynamic pricing for peak seasons</p>
                                    </div>
                                </div>
                                <svg class="w-5 h-5 text-gray-400 transform transition-transform" id="icon-seasonal-rates" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                                </svg>
                            </button>
                            
                            <div id="seasonal-rates" class="hidden px-6 pb-6">
                                <div class="space-y-4 text-gray-300">
                                    <div class="bg-gray-800 rounded-lg p-4">
                                        <h4 class="font-semibold text-white mb-2">What are Seasonal Rates?</h4>
                                        <p class="text-sm">Seasonal rates allow you to set special pricing for specific time periods (e.g., summer peak, Christmas holidays). When active, they override the base room type price.</p>
                                    </div>
                                    <div class="bg-gray-800 rounded-lg p-4">
                                        <h4 class="font-semibold text-white mb-2">How to Create a Seasonal Rate</h4>
                                        <ol class="text-sm space-y-2 list-decimal list-inside ml-2">
                                            <li>Navigate to "Seasonal Rates"</li>
                                            <li>Click "+ Add Season Rate"</li>
                                            <li>Enter season name (e.g., "Summer Peak 2026")</li>
                                            <li>Select room type</li>
                                            <li>Set start and end dates</li>
                                            <li>Enter special price per night</li>
                                            <li>Activate the rate</li>
                                            <li>System prevents overlapping dates for same room type</li>
                                        </ol>
                                    </div>
                                    <div class="bg-gray-800 rounded-lg p-4">
                                        <h4 class="font-semibold text-white mb-2">Rate Status Types</h4>
                                        <ul class="text-sm space-y-2 ml-2">
                                            <li>• <strong class="text-blue-400">Ongoing Now:</strong> Currently active and applying to bookings</li>
                                            <li>• <strong class="text-green-400">Active (Scheduled):</strong> Set for future dates</li>
                                            <li>• <strong class="text-orange-400">Disabled:</strong> Not applying to any bookings</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 6. Payments -->
                        <div class="bg-gray-900 border border-gray-800 rounded-xl overflow-hidden">
                            <button onclick="toggleSection('payments')" 
                                    class="w-full px-6 py-4 flex items-center justify-between hover:bg-gray-800 transition-colors">
                                <div class="flex items-center">
                                    <span class="w-10 h-10 bg-emerald-600 rounded-lg flex items-center justify-center mr-4">
                                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/>
                                        </svg>
                                    </span>
                                    <div class="text-left">
                                        <h3 class="text-lg font-semibold text-white">Payment Processing</h3>
                                        <p class="text-sm text-gray-400">Recording and tracking payments</p>
                                    </div>
                                </div>
                                <svg class="w-5 h-5 text-gray-400 transform transition-transform" id="icon-payments" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                                </svg>
                            </button>
                            
                            <div id="payments" class="hidden px-6 pb-6">
                                <div class="space-y-4 text-gray-300">
                                    <div class="bg-gray-800 rounded-lg p-4">
                                        <h4 class="font-semibold text-white mb-2">Payment Methods</h4>
                                        <ul class="text-sm space-y-1 ml-2">
                                            <li>• Cash</li>
                                            <li>• Credit Card</li>
                                            <li>• Debit Card</li>
                                            <li>• Bank Transfer</li>
                                            <li>• Online Payment</li>
                                        </ul>
                                    </div>
                                    <div class="bg-gray-800 rounded-lg p-4">
                                        <h4 class="font-semibold text-white mb-2">Payment Types</h4>
                                        <ul class="text-sm space-y-1 ml-2">
                                            <li>• <strong>Deposit:</strong> Advance payment to secure booking</li>
                                            <li>• <strong>Full Payment:</strong> Complete amount paid upfront</li>
                                            <li>• <strong>Balance:</strong> Remaining amount at check-out</li>
                                            <li>• <strong>Refund:</strong> Money returned to guest</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <!-- FAQ Section -->
                    <div class="mt-12 bg-gray-900 border border-gray-800 rounded-xl p-6">
                        <h2 class="text-xl font-bold text-white mb-6 flex items-center">
                            <svg class="w-6 h-6 mr-2 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            Frequently Asked Questions
                        </h2>
                        <div class="space-y-4">
                            <div class="bg-gray-800 rounded-lg p-4">
                                <h4 class="font-semibold text-white mb-2">Q: How do seasonal rates work?</h4>
                                <p class="text-sm text-gray-400">A: Seasonal rates automatically override base room prices during specified date ranges. The system checks for active seasonal rates when calculating reservation totals. If a seasonal rate exists for the booking dates, it will be used instead of the base price.</p>
                            </div>
                            <div class="bg-gray-800 rounded-lg p-4">
                                <h4 class="font-semibold text-white mb-2">Q: Can I cancel a reservation?</h4>
                                <p class="text-sm text-gray-400">A: Yes, navigate to the reservation details and click "Cancel Reservation". The room will automatically become available again and any associated payments can be processed as refunds.</p>
                            </div>
                            <div class="bg-gray-800 rounded-lg p-4">
                                <h4 class="font-semibold text-white mb-2">Q: What happens if I create overlapping seasonal rates?</h4>
                                <p class="text-sm text-gray-400">A: The system prevents this! You cannot create overlapping seasonal rates for the same room type. You'll receive an error message asking you to adjust the dates or deactivate the conflicting rate first.</p>
                            </div>
                            <div class="bg-gray-800 rounded-lg p-4">
                                <h4 class="font-semibold text-white mb-2">Q: How do I mark a room for maintenance?</h4>
                                <p class="text-sm text-gray-400">A: Go to the Rooms list, find the room, and change its status to "Maintenance". The room will be unavailable for new bookings until you change it back to "Available".</p>
                            </div>
                            <div class="bg-gray-800 rounded-lg p-4">
                                <h4 class="font-semibold text-white mb-2">Q: Can a guest have multiple reservations?</h4>
                                <p class="text-sm text-gray-400">A: Yes! A single guest can have multiple reservations. Each reservation will have a unique reservation number (e.g., RES-000001, RES-000002).</p>
                            </div>
                        </div>
                    </div>

                    <!-- Need More Help -->
                    <div class="mt-8 bg-gradient-to-r from-primary-600/20 to-blue-600/20 border border-primary-500/30 rounded-xl p-6 text-center">
                        <svg class="w-12 h-12 mx-auto text-primary-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 5.636l-3.536 3.536m0 5.656l3.536 3.536M9.172 9.172L5.636 5.636m3.536 9.192l-3.536 3.536M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-5 0a4 4 0 11-8 0 4 4 0 018 0z"/>
                        </svg>
                        <h3 class="text-lg font-bold text-white mb-2">Need More Help?</h3>
                        <p class="text-sm text-gray-300 mb-4">Can't find what you're looking for? Contact your system administrator for additional assistance.</p>
                        <button onclick="window.print()" class="px-6 py-2.5 bg-primary-600 hover:bg-primary-500 text-white font-medium rounded-lg transition-colors inline-flex items-center">
                            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"/>
                            </svg>
                            Print This Guide
                        </button>
                    </div>

                </div>
            </main>
        </div>
    </div>

    <script>
        function toggleSection(sectionId) {
            const section = document.getElementById(sectionId);
            const icon = document.getElementById('icon-' + sectionId);
            
            if (section.classList.contains('hidden')) {
                section.classList.remove('hidden');
                icon.classList.add('rotate-180');
            } else {
                section.classList.add('hidden');
                icon.classList.remove('rotate-180');
            }
        }

        // Search functionality
        document.getElementById('helpSearch').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            
            if (searchTerm === '') {
                // Reset: close all sections
                document.querySelectorAll('[id^="icon-"]').forEach(icon => {
                    const sectionId = icon.id.replace('icon-', '');
                    const section = document.getElementById(sectionId);
                    if (section && !section.classList.contains('hidden')) {
                        section.classList.add('hidden');
                        icon.classList.remove('rotate-180');
                    }
                });
                return;
            }
            
            // Search through all sections
            document.querySelectorAll('[id^="getting-started"], [id^="guest-mgmt"], [id^="reservation"], [id^="room-mgmt"], [id^="seasonal-rates"], [id^="payments"]').forEach(section => {
                const text = section.textContent.toLowerCase();
                const icon = document.getElementById('icon-' + section.id);
                
                if (text.includes(searchTerm)) {
                    section.classList.remove('hidden');
                    if (icon) icon.classList.add('rotate-180');
                } else {
                    section.classList.add('hidden');
                    if (icon) icon.classList.remove('rotate-180');
                }
            });
        });

        // Open all sections
        function openAllSections() {
            document.querySelectorAll('[id^="getting-started"], [id^="guest-mgmt"], [id^="reservation"], [id^="room-mgmt"], [id^="seasonal-rates"], [id^="payments"]').forEach(section => {
                section.classList.remove('hidden');
                const icon = document.getElementById('icon-' + section.id);
                if (icon) icon.classList.add('rotate-180');
            });
        }

        // Keyboard shortcut: Ctrl+K to focus search
        document.addEventListener('keydown', function(e) {
            if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
                e.preventDefault();
                document.getElementById('helpSearch').focus();
            }
        });
    </script>
</body>
</html>