<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Login — Ocean View Resort</title>
    
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
                            50: '#f0f4ff', 100: '#e8f0fb',
                            500: '#1B4F8A', 600: '#163d6e', 700: '#0f2a4d'
                        }
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-950 text-gray-100">
    
    <!-- Background Pattern -->
    <div class="fixed inset-0 -z-10 overflow-hidden">
        <div class="absolute inset-0 bg-gradient-to-br from-primary-700/20 via-gray-950 to-gray-950"></div>
        <div class="absolute inset-0 opacity-20" style="background-image: radial-gradient(circle at 2px 2px, rgb(27, 79, 138) 1px, transparent 0); background-size: 40px 40px;"></div>
    </div>

    <div class="min-h-screen flex items-center justify-center p-4">
        <div class="w-full max-w-md">
            
            <!-- Logo & Branding -->
            <div class="text-center mb-8">
                <div class="inline-flex items-center justify-center w-20 h-20 bg-gradient-to-br from-primary-600 to-primary-700 rounded-2xl shadow-lg mb-4 border border-primary-500/30">
                    <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
                    </svg>
                </div>
                <h1 class="text-3xl font-bold text-white mb-2">Ocean View Resort</h1>
                <p class="text-gray-400 text-sm">Staff Management Portal</p>
            </div>

            <!-- Login Card -->
            <div class="bg-gray-900 border border-gray-800 rounded-2xl shadow-2xl overflow-hidden">
                
                <!-- Header -->
                <div class="bg-gradient-to-r from-primary-600/20 to-primary-700/20 px-8 py-6 border-b border-gray-800">
                    <h2 class="text-2xl font-bold text-white text-center">Sign In</h2>
                    <p class="text-gray-400 text-sm text-center mt-1">Welcome back! Please login to continue</p>
                </div>

                <!-- Messages (Hidden - Using Toast Instead) -->
                <div class="px-8 pt-6 hidden">
                    <!-- Status messages are now shown via toast notifications -->
                </div>

                <!-- Login Form -->
                <form action="${pageContext.request.contextPath}/login" method="post" class="px-8 pb-8 pt-2">
                    
                    <!-- Username/Email Field -->
                    <div class="mb-5">
                        <label for="usernameOrEmail" class="block text-sm font-medium text-gray-300 mb-2">
                            Username or Email
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <svg class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                                </svg>
                            </div>
                            <input type="text" 
                                   id="usernameOrEmail" 
                                   name="usernameOrEmail"
                                   placeholder="Enter username or email" 
                                   required 
                                   autofocus
                                   class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg pl-10 pr-4 py-3 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20 focus:outline-none transition-all">
                        </div>
                    </div>

                    <!-- Password Field -->
                    <div class="mb-6">
                        <label for="password" class="block text-sm font-medium text-gray-300 mb-2">
                            Password
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <svg class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                                </svg>
                            </div>
                            <input type="password" 
                                   id="password" 
                                   name="password"
                                   placeholder="Enter your password" 
                                   required
                                   class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg pl-10 pr-4 py-3 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20 focus:outline-none transition-all">
                        </div>
                    </div>

                    <!-- Login Button -->
                    <button type="submit" 
                            class="w-full bg-gradient-to-br from-primary-600 to-primary-700 hover:from-primary-500 hover:to-primary-600 text-white font-semibold py-3 px-4 rounded-lg transition-all duration-300 shadow-lg shadow-primary-600/20 hover:shadow-primary-600/40 border border-primary-500/30">
                        <span class="flex items-center justify-center space-x-2">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"/>
                            </svg>
                            <span>Sign In</span>
                        </span>
                    </button>

                    <!-- Register Link -->
                    <div class="mt-6 text-center">
                        <p class="text-sm text-gray-400">
                            Don't have an account? 
                            <a href="${pageContext.request.contextPath}/register" 
                               class="text-primary-400 hover:text-primary-300 font-semibold transition-colors">
                                Register here
                            </a>
                        </p>
                    </div>
                </form>

            </div>

            <!-- Footer -->
            <div class="mt-8 text-center text-sm text-gray-500">
                <p>&copy; 2026 Ocean View Resort. All rights reserved.</p>
            </div>

        </div>
    </div>

    <!-- Toast Notification -->
    <div id="custom-toast" class="fixed bottom-6 right-6 z-50 transition-all duration-400 transform translate-y-8 opacity-0 pointer-events-none">
        <div class="bg-gradient-to-br from-primary-600 to-gray-900 border border-primary-500/30 rounded-2xl shadow-[0_10px_40px_rgba(0,0,0,0.5)] p-4 flex items-center justify-between gap-8 min-w-[360px] pointer-events-auto">
            <div class="flex flex-col">
                <span id="toast-title" class="text-white font-semibold text-[15px] tracking-wide">Event has been created</span>
                <span id="toast-subtitle" class="text-primary-100 opacity-80 text-[13px] mt-0.5">Sunday, December 03, 2023 at 9:00 AM</span>
            </div>
            <button onclick="hideToast()" class="bg-white hover:bg-gray-100 text-primary-700 text-[14px] font-semibold px-4 py-1.5 rounded-lg transition-colors focus:outline-none shadow-sm">
                Dismiss
            </button>
        </div>
    </div>

    <script>
        let toastTimeout;

        function showToast(title) {
            const toast = document.getElementById('custom-toast');
            document.getElementById('toast-title').textContent = title;

            const now = new Date();
            const formattedDate = new Intl.DateTimeFormat('en-US', {
                weekday: 'long', month: 'long', day: '2-digit', year: 'numeric',
                hour: 'numeric', minute: '2-digit', hour12: true
            }).format(now).replace(' at ', ' at ');

            document.getElementById('toast-subtitle').textContent = formattedDate;

            toast.classList.remove('translate-y-8', 'opacity-0');
            toast.classList.add('translate-y-0', 'opacity-100');

            clearTimeout(toastTimeout);
            toastTimeout = setTimeout(() => {
                hideToast();
            }, 4500);
        }

        function hideToast() {
            const toast = document.getElementById('custom-toast');
            toast.classList.remove('translate-y-0', 'opacity-100');
            toast.classList.add('translate-y-8', 'opacity-0');
        }

        document.addEventListener("DOMContentLoaded", function() {
            <c:if test="${param.status == 'loggedout'}">showToast("Logged out successfully");</c:if>
            <c:if test="${param.status == 'sessionExpired'}">showToast("Your session has expired");</c:if>
            <c:if test="${param.status == 'error'}">showToast("Invalid username or password");</c:if>
            <c:if test="${param.status == 'registered'}">showToast("Registration successful!");</c:if>
        });
    </script>

</body>
</html>