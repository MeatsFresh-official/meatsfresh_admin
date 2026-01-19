<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/includes/header.jsp" %>

        <main class="main-content bg-gray-50/50 min-h-screen">
            <div class="container-fluid px-6 py-8">

                <!-- Header -->
                <div class="mb-8 animate-fade-in-down">
                    <h1 class="text-3xl font-extrabold text-gray-900 tracking-tight lg:text-4xl">Order Controls</h1>
                    <p class="mt-2 text-gray-500 font-medium">Manage fees and adjustments for Order #${order.id}</p>
                </div>

                <div class="row justify-content-center">
                    <!-- Full width with padding constraint -->
                    <div class="col-12 col-xl-10">

                        <!-- Premium Card -->
                        <div
                            class="bg-white rounded-[2rem] shadow-xl shadow-gray-200/50 overflow-hidden border border-gray-100 animate-fade-in-up">
                            <div class="p-8 border-b border-gray-50 bg-gradient-to-r from-indigo-50/50 to-white">
                                <div class="flex items-center gap-3">
                                    <div
                                        class="w-12 h-12 rounded-2xl bg-indigo-600 text-white flex items-center justify-center shadow-lg shadow-indigo-200">
                                        <i class="fas fa-sliders-h text-lg"></i>
                                    </div>
                                    <div>
                                        <h5 class="text-xl font-bold text-gray-900 mb-0">Charge Configurations</h5>
                                        <p class="text-sm text-gray-500 mb-0 font-medium">Toggle and adjust specific
                                            order fees</p>
                                    </div>
                                </div>
                            </div>

                            <div class="p-8">
                                <form id="chargesForm"
                                    action="${pageContext.request.contextPath}/admin/orders/updateCharges"
                                    method="post">
                                    <input type="hidden" name="orderId" value="${order.id}">

                                    <!-- Fee Configuration Grid -->
                                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">

                                        <!-- 1. Delivery (Base + Per KM) -->
                                        <div class="fee-card group">
                                            <div class="flex items-center justify-between mb-4">
                                                <div class="flex items-center gap-3">
                                                    <div
                                                        class="w-10 h-10 rounded-xl bg-orange-50 text-orange-600 flex items-center justify-center">
                                                        <i class="fas fa-truck text-sm"></i>
                                                    </div>
                                                    <span class="font-bold text-gray-700">Delivery Config</span>
                                                </div>
                                                <label class="switch-ios">
                                                    <input type="checkbox" class="charge-toggle"
                                                        name="deliveryFeeEnabled" ${order.deliveryFee> 0 ? 'checked' :
                                                    ''} onchange="toggleGroup('deliveryGroup', this.checked)">
                                                    <span class="slider round"></span>
                                                </label>
                                            </div>
                                            <div id="deliveryGroup"
                                                class="space-y-3 ${order.deliveryFee <= 0 ? 'hidden-input' : ''}">
                                                <div class="input-wrapper">
                                                    <label
                                                        class="text-xs font-bold text-gray-400 uppercase tracking-wider ml-1 mb-1 block">Base
                                                        Fee</label>
                                                    <div class="relative">
                                                        <span
                                                            class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400 font-bold">${currencySymbol}</span>
                                                        <input type="number" class="form-input-premium pl-8"
                                                            name="baseDeliveryFee" value="${order.deliveryFee}"
                                                            step="0.01" min="0" placeholder="0.00">
                                                    </div>
                                                </div>
                                                <div class="input-wrapper">
                                                    <label
                                                        class="text-xs font-bold text-gray-400 uppercase tracking-wider ml-1 mb-1 block">Fee
                                                        Per KM</label>
                                                    <div class="relative">
                                                        <span
                                                            class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400 font-bold">${currencySymbol}</span>
                                                        <input type="number" class="form-input-premium pl-8"
                                                            name="deliveryFeePerKm" value="" step="0.01" min="0"
                                                            placeholder="0.00">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- 2. Platform (Rate) -->
                                        <div class="fee-card group">
                                            <div class="flex items-center justify-between mb-4">
                                                <div class="flex items-center gap-3">
                                                    <div
                                                        class="w-10 h-10 rounded-xl bg-purple-50 text-purple-600 flex items-center justify-center">
                                                        <i class="fas fa-desktop text-sm"></i>
                                                    </div>
                                                    <span class="font-bold text-gray-700">Platform</span>
                                                </div>
                                                <label class="switch-ios">
                                                    <input type="checkbox" class="charge-toggle"
                                                        name="platformFeeEnabled" ${order.platformFee> 0 ? 'checked' :
                                                    ''} onchange="toggleGroup('platformGroup', this.checked)">
                                                    <span class="slider round"></span>
                                                </label>
                                            </div>
                                            <div id="platformGroup"
                                                class="input-wrapper ${order.platformFee <= 0 ? 'hidden-input' : ''}">
                                                <label
                                                    class="text-xs font-bold text-gray-400 uppercase tracking-wider ml-1 mb-1 block">Platform
                                                    Rate</label>
                                                <div class="relative">
                                                    <input type="number" class="form-input-premium pr-8"
                                                        name="platformFeeRate" value="${order.platformFee}" step="0.1"
                                                        min="0" placeholder="0.0">
                                                    <span
                                                        class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 font-bold">%</span>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- 3. Rain (Fee) -->
                                        <div class="fee-card group">
                                            <div class="flex items-center justify-between mb-4">
                                                <div class="flex items-center gap-3">
                                                    <div
                                                        class="w-10 h-10 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center">
                                                        <i class="fas fa-cloud-rain text-sm"></i>
                                                    </div>
                                                    <span class="font-bold text-gray-700">Rain / Surge</span>
                                                </div>
                                                <label class="switch-ios">
                                                    <input type="checkbox" class="charge-toggle" name="rainFeeEnabled"
                                                        ${order.rainFee> 0 ? 'checked' : ''}
                                                    onchange="toggleGroup('rainGroup', this.checked)">
                                                    <span class="slider round"></span>
                                                </label>
                                            </div>
                                            <div id="rainGroup"
                                                class="input-wrapper ${order.rainFee <= 0 ? 'hidden-input' : ''}">
                                                <label
                                                    class="text-xs font-bold text-gray-400 uppercase tracking-wider ml-1 mb-1 block">Surge
                                                    Fee</label>
                                                <div class="relative">
                                                    <span
                                                        class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400 font-bold">${currencySymbol}</span>
                                                    <input type="number" class="form-input-premium pl-8" name="rainFee"
                                                        value="${order.rainFee}" step="1" min="0" placeholder="0">
                                                </div>
                                            </div>
                                        </div>

                                        <!-- 4. Packaging -->
                                        <div class="fee-card group">
                                            <div class="flex items-center justify-between mb-4">
                                                <div class="flex items-center gap-3">
                                                    <div
                                                        class="w-10 h-10 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center">
                                                        <i class="fas fa-box-open text-sm"></i>
                                                    </div>
                                                    <span class="font-bold text-gray-700">Packaging</span>
                                                </div>
                                                <label class="switch-ios">
                                                    <input type="checkbox" class="charge-toggle"
                                                        name="packagingChargeEnabled" ${order.packagingFee> 0 ?
                                                    'checked' : ''} onchange="toggleGroup('packagingGroup',
                                                    this.checked)">
                                                    <span class="slider round"></span>
                                                </label>
                                            </div>
                                            <div id="packagingGroup"
                                                class="input-wrapper ${order.packagingFee <= 0 ? 'hidden-input' : ''}">
                                                <label
                                                    class="text-xs font-bold text-gray-400 uppercase tracking-wider ml-1 mb-1 block">Packaging
                                                    Charge</label>
                                                <div class="relative">
                                                    <span
                                                        class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400 font-bold">${currencySymbol}</span>
                                                    <input type="number" class="form-input-premium pl-8"
                                                        name="packagingCharge" value="${order.packagingFee}" step="0.01"
                                                        min="0" placeholder="0.00">
                                                </div>
                                            </div>
                                        </div>

                                        <!-- 5. Service Charge (Restored) -->
                                        <div class="fee-card group">
                                            <div class="flex items-center justify-between mb-4">
                                                <div class="flex items-center gap-3">
                                                    <div
                                                        class="w-10 h-10 rounded-xl bg-pink-50 text-pink-600 flex items-center justify-center">
                                                        <i class="fas fa-concierge-bell text-sm"></i>
                                                    </div>
                                                    <span class="font-bold text-gray-700">Service</span>
                                                </div>
                                                <label class="switch-ios">
                                                    <input type="checkbox" class="charge-toggle"
                                                        name="serviceChargeEnabled"
                                                        onchange="toggleGroup('serviceGroup', this.checked)">
                                                    <span class="slider round"></span>
                                                </label>
                                            </div>
                                            <div id="serviceGroup" class="input-wrapper hidden-input">
                                                <label
                                                    class="text-xs font-bold text-gray-400 uppercase tracking-wider ml-1 mb-1 block">Service
                                                    Charge</label>
                                                <div class="relative">
                                                    <span
                                                        class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400 font-bold">${currencySymbol}</span>
                                                    <input type="number" class="form-input-premium pl-8"
                                                        name="serviceCharge" value="" step="0.01" min="0"
                                                        placeholder="0.00">
                                                </div>
                                            </div>
                                        </div>

                                        <!-- 6. GST -->
                                        <div class="fee-card group">
                                            <div class="flex items-center justify-between mb-4">
                                                <div class="flex items-center gap-3">
                                                    <div
                                                        class="w-10 h-10 rounded-xl bg-teal-50 text-teal-600 flex items-center justify-center">
                                                        <i class="fas fa-percentage text-sm"></i>
                                                    </div>
                                                    <span class="font-bold text-gray-700">GST / Tax</span>
                                                </div>
                                                <label class="switch-ios">
                                                    <input type="checkbox" class="charge-toggle" name="gstFeeEnabled"
                                                        ${order.gst> 0 ? 'checked' : ''}
                                                    onchange="toggleGroup('gstGroup', this.checked)">
                                                    <span class="slider round"></span>
                                                </label>
                                            </div>
                                            <div id="gstGroup"
                                                class="input-wrapper ${order.gst <= 0 ? 'hidden-input' : ''}">
                                                <label
                                                    class="text-xs font-bold text-gray-400 uppercase tracking-wider ml-1 mb-1 block">Applicable
                                                    Tax Rate</label>
                                                <div class="relative">
                                                    <input type="number" class="form-input-premium pr-8" name="gstRate"
                                                        value="${order.gst}" step="0.1" min="0" placeholder="0.0">
                                                    <span
                                                        class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 font-bold">%</span>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                            </div>

                            <!-- Save Action -->
                            <button type="submit"
                                class="w-full py-4 rounded-xl bg-indigo-600 text-white font-bold text-lg shadow-lg shadow-indigo-200 hover:shadow-xl hover:-translate-y-1 transition-all duration-300">
                                Save Fee Configuration
                            </button>

                            </form>
                        </div>
                    </div>
                </div>

            </div>
            </div>

            </div>
        </main>

        <%@ include file="/includes/footer.jsp" %>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/view-cartpage.css">
            <script src="${pageContext.request.contextPath}/resources/js/view-cartpage.js"></script>

            <style>
                /* Premium Design System */
                .animate-fade-in-down {
                    animation: fadeInDown 0.6s ease-out forwards;
                }

                .animate-fade-in-up {
                    animation: fadeInUp 0.6s ease-out forwards;
                }

                @keyframes fadeInDown {
                    from {
                        opacity: 0;
                        transform: translateY(-20px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                @keyframes fadeInUp {
                    from {
                        opacity: 0;
                        transform: translateY(20px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                /* Fee Cards */
                .fee-card {
                    padding: 1.25rem;
                    background: #fff;
                    border: 2px solid #f3f4f6;
                    border-radius: 1.25rem;
                    transition: all 0.2s;
                }

                .fee-card:hover,
                .fee-card:focus-within {
                    border-color: #c7d2fe;
                    box-shadow: 0 4px 12px rgba(99, 102, 241, 0.05);
                }

                /* iOS Toggle */
                .switch-ios {
                    position: relative;
                    display: inline-block;
                    width: 44px;
                    height: 24px;
                }

                .switch-ios input {
                    opacity: 0;
                    width: 0;
                    height: 0;
                }

                .slider {
                    position: absolute;
                    cursor: pointer;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    background-color: #e5e7eb;
                    transition: .4s;
                    border-radius: 34px;
                }

                .slider:before {
                    position: absolute;
                    content: "";
                    height: 20px;
                    width: 20px;
                    left: 2px;
                    bottom: 2px;
                    background-color: white;
                    transition: .4s;
                    border-radius: 50%;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }

                input:checked+.slider {
                    background-color: #4f46e5;
                }

                input:checked+.slider:before {
                    transform: translateX(20px);
                }

                /* Inputs */
                .form-input-premium {
                    width: 100%;
                    padding: 0.75rem 1rem;
                    background-color: #f9fafb;
                    border: 1px solid #e5e7eb;
                    border-radius: 0.75rem;
                    font-weight: 500;
                    color: #1f2937;
                    transition: all 0.2s;
                }

                .form-input-premium:focus {
                    background-color: #fff;
                    border-color: #6366f1;
                    box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
                    outline: none;
                }

                .hidden-input {
                    display: none;
                }

                .input-wrapper {
                    margin-top: 1rem;
                    animation: fadeIn 0.3s ease-out;
                }

                @keyframes fadeIn {
                    from {
                        opacity: 0;
                        transform: translateY(-5px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }
            </style>

            <script>
                // Global variables
                const currencySymbol = '${currencySymbol}';
                const orderId = '${order.id}';

                /**
                 * Toggles visibility of a fee input group
                 * @param {string} groupId - The ID of the container element
                 * @param {boolean} isChecked - The state of the toggle switch
                 */
                function toggleGroup(groupId, isChecked) {
                    const group = document.getElementById(groupId);
                    if (!group) return;

                    if (isChecked) {
                        group.classList.remove('hidden-input');
                        // Find and focus the first input if available
                        const input = group.querySelector('input');
                        if (input) {
                            if (!input.value) input.value = "0"; // Set default if empty
                            // input.focus(); // Optional: focus user
                        }
                    } else {
                        group.classList.add('hidden-input');
                    }
                }

                /**
                 * Adds a new custom fee entry row
                 */
                function addCustomFee() {
                    const container = document.getElementById('customFeesContainer');
                    if (!container) return;

                    const div = document.createElement('div');
                    div.className = 'flex gap-3 custom-fee-entry animate-fade-in-up mb-3';
                    div.innerHTML = `
                        <input type="text" class="form-input-premium flex-grow" name="customFeeNames" placeholder="Name (e.g. Tip)" required>
                        <div class="relative w-32">
                            <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-sm font-bold">${currencySymbol}</span>
                            <input type="number" class="form-input-premium pl-6" name="customFeeValues" placeholder="0.00" step="0.01" min="0" required>
                        </div>
                        <button type="button" class="w-10 h-10 flex items-center justify-center rounded-xl bg-red-50 text-red-500 hover:bg-red-500 hover:text-white transition-all remove-custom-fee" onclick="this.parentElement.remove()">
                            <i class="fas fa-times"></i>
                        </button>
                    `;
                    container.appendChild(div);
                }

                // Initialize on load to handle pre-checked states (e.g. browser back button or error reload)
                document.addEventListener('DOMContentLoaded', function () {
                    const toggles = document.querySelectorAll('.charge-toggle');
                    toggles.forEach(toggle => {
                        // Extract group ID from the onchange attribute string, or inferred from name. 
                        // But since we have inline onchange="toggleGroup('ID', ...)", we can just trigger it.
                        // However, simpler is to just check the ID referenced in the onchange handler.
                        // Or we can manually run the logic for each.

                        // We will rely on the inline logic being correct, but we might want to ensure 
                        // the initial state matches the checkbox.
                        // The JSP rendering handles the initial class='hidden-input' based on values, so we might be ok.
                        // But let's be safe.
                        const onchange = toggle.getAttribute('onchange');
                        if (onchange && onchange.includes("toggleGroup")) {
                            // Primitive parsing to find the ID
                            const match = onchange.match(/'([^']+)'/);
                            if (match && match[1]) {
                                toggleGroup(match[1], toggle.checked);
                            }
                        }
                    });
                });
            </script>