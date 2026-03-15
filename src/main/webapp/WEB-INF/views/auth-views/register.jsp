<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Registration — Ocean View Resort</title>
    
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
        <div class="w-full max-w-3xl">
            
            <!-- Logo & Branding -->
            <div class="text-center mb-8">
                <div class="inline-flex items-center justify-center w-20 h-20 bg-gradient-to-br from-primary-600 to-primary-700 rounded-2xl shadow-lg mb-4 border border-primary-500/30">
                    <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
                    </svg>
                </div>
                <h1 class="text-3xl font-bold text-white mb-2">Ocean View Resort</h1>
                <p class="text-gray-400 text-sm">Staff Registration Portal</p>
            </div>

            <!-- Registration Card -->
            <div class="bg-gray-900 border border-gray-800 rounded-2xl shadow-2xl overflow-hidden">
                
                <!-- Header -->
                <div class="bg-gradient-to-r from-primary-600/20 to-primary-700/20 px-8 py-6 border-b border-gray-800">
                    <h2 class="text-2xl font-bold text-white text-center">Create Account</h2>
                    <p class="text-gray-400 text-sm text-center mt-1">Join the Ocean View Resort team</p>
                </div>

                <!-- Registration Form - 2 COLUMNS -->
                <form action="${pageContext.request.contextPath}/register" method="post" class="px-8 pb-8 pt-6">
                    
                    <!-- GRID: 2 Columns -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-5">
                        
                        <!-- Full Name Field -->
                        <div>
                            <label for="fullName" class="block text-sm font-medium text-gray-300 mb-2">
                                Full Name <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <svg class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                                    </svg>
                                </div>
                                <input type="text" 
                                       id="fullName" 
                                       name="fullName"
                                       placeholder="Enter your full name" 
                                       required 
                                       autofocus
                                       value="${param.fullName}"
                                       class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg pl-10 pr-4 py-3 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20 focus:outline-none transition-all">
                            </div>
                        </div>

                        <!-- Email Field -->
                        <div>
                            <label for="email" class="block text-sm font-medium text-gray-300 mb-2">
                                Email Address <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <svg class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                                    </svg>
                                </div>
                                <input type="email" 
                                       id="email" 
                                       name="email"
                                       placeholder="your.email@oceanview.lk" 
                                       required
                                       value="${param.email}"
                                       class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg pl-10 pr-4 py-3 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20 focus:outline-none transition-all">
                            </div>
                        </div>

                        <!-- Username Field -->
                        <div>
                            <label for="userName" class="block text-sm font-medium text-gray-300 mb-2">
                                Username <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <svg class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z"/>
                                    </svg>
                                </div>
                                <input type="text" 
                                       id="userName" 
                                       name="userName"
                                       placeholder="Choose a username" 
                                       required
                                       value="${param.userName}"
                                       class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg pl-10 pr-4 py-3 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20 focus:outline-none transition-all">
                            </div>
                        </div>

                        <!-- Role Field -->
                        <div>
                            <label for="role" class="block text-sm font-medium text-gray-300 mb-2">
                                Role <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <svg class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                                    </svg>
                                </div>
                                <select id="role" 
                                        name="role"
                                        required
                                        class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg pl-10 pr-10 py-3 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20 focus:outline-none transition-all appearance-none">
                                    <option value="" class="bg-gray-900">-- Select Role --</option>
                                    <option value="Admin" class="bg-gray-900" ${param.role == 'Admin' ? 'selected' : ''}>Admin</option>
                                    <option value="FrontDesk" class="bg-gray-900" ${param.role == 'FrontDesk' ? 'selected' : ''}>Front Desk</option>
                                    <option value="Housekeeping" class="bg-gray-900" ${param.role == 'Housekeeping' ? 'selected' : ''}>Housekeeping</option>
                                    <option value="Manager" class="bg-gray-900" ${param.role == 'Manager' ? 'selected' : ''}>Manager</option>
                                </select>
                                <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
                                    <svg class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                                    </svg>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Password Field - FULL WIDTH -->
                    <div class="mb-6">
                        <label for="password" class="block text-sm font-medium text-gray-300 mb-2">
                            Password <span class="text-red-500">*</span>
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
                                   placeholder="At least 8 characters" 
                                   required
                                   minlength="8"
                                   class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg pl-10 pr-4 py-3 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20 focus:outline-none transition-all">
                        </div>
                        <p class="text-xs text-gray-500 mt-1.5">Must be at least 8 characters long</p>
                    </div>

                    <!-- Register Button -->
                    <button type="submit" 
                            class="w-full bg-gradient-to-br from-primary-600 to-primary-700 hover:from-primary-500 hover:to-primary-600 text-white font-semibold py-3 px-4 rounded-lg transition-all duration-300 shadow-lg shadow-primary-600/20 hover:shadow-primary-600/40 border border-primary-500/30">
                        <span class="flex items-center justify-center space-x-2">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/>
                            </svg>
                            <span>Create Account</span>
                        </span>
                    </button>

                    <!-- Login Link -->
                    <div class="mt-6 text-center">
                        <p class="text-sm text-gray-400">
                            Already have an account? 
                            <a href="${pageContext.request.contextPath}/login" 
                               class="text-primary-400 hover:text-primary-300 font-semibold transition-colors">
                                Sign in here
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
        <div class="bg-gradient-to-br from-red-600 to-gray-900 border border-red-500/30 rounded-2xl shadow-[0_10px_40px_rgba(0,0,0,0.5)] p-4 flex items-center justify-between gap-8 min-w-[360px] pointer-events-auto">
            <div class="flex flex-col">
                <span id="toast-title" class="text-white font-semibold text-[15px] tracking-wide">Error</span>
                <span id="toast-subtitle" class="text-red-100 opacity-80 text-[13px] mt-0.5">Please try again</span>
            </div>
            <button onclick="hideToast()" class="bg-white hover:bg-gray-100 text-red-700 text-[14px] font-semibold px-4 py-1.5 rounded-lg transition-colors focus:outline-none shadow-sm">
                Dismiss
            </button>
        </div>
    </div>

    <script>
        let toastTimeout;

        function showToast(title, subtitle, isError = true) {
            const toast = document.getElementById('custom-toast');
            const toastDiv = toast.querySelector('div');
            
            if (isError) {
                toastDiv.classList.remove('from-green-600', 'border-green-500/30');
                toastDiv.classList.add('from-red-600', 'border-red-500/30');
                toastDiv.querySelector('button').classList.remove('text-green-700');
                toastDiv.querySelector('button').classList.add('text-red-700');
                document.getElementById('toast-subtitle').classList.remove('text-green-100');
                document.getElementById('toast-subtitle').classList.add('text-red-100');
            } else {
                toastDiv.classList.remove('from-red-600', 'border-red-500/30');
                toastDiv.classList.add('from-green-600', 'border-green-500/30');
                toastDiv.querySelector('button').classList.remove('text-red-700');
                toastDiv.querySelector('button').classList.add('text-green-700');
                document.getElementById('toast-subtitle').classList.remove('text-red-100');
                document.getElementById('toast-subtitle').classList.add('text-green-100');
            }
            
            document.getElementById('toast-title').textContent = title;
            document.getElementById('toast-subtitle').textContent = subtitle;
            
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
            <c:if test="${param.status == 'error'}">
                showToast("Registration Failed", "Username already exists. Please try another.", true);
            </c:if>
            <c:if test="${param.status == 'invalid'}">
                showToast("Invalid Password", "Password must be at least 8 characters long.", true);
            </c:if>
        });
    </script>
</body>
</html>