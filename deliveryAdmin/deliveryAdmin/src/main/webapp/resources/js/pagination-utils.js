/**
 * Zenith PaginationUtils
 * A reusable class for Client-Side Pagination.
 * 
 * Usage:
 * const paginator = new PaginationUtils('paginationContainerId', 10, (paginatedItems) => {
 *     // Render your table rows here
 *     myRenderFunction(paginatedItems);
 * });
 * 
 * // When data is loaded:
 * paginator.setData(allItemsArray);
 */
class PaginationUtils {
    constructor(containerId, itemsPerPage, onRender) {
        this.containerId = containerId;
        this.itemsPerPage = itemsPerPage || 10;
        this.onRender = onRender;
        this.currentPage = 1;
        this.allItems = [];
        this.showPerPageSelection = true;
    }

    /**
     * Set the full dataset and reset to page 1.
     * @param {Array} items - The full array of data items.
     */
    setData(items) {
        this.allItems = items || [];
        this.currentPage = 1;
        this.updateUI();
    }

    /**
     * Updates the UI: calculates slice, triggers render callback, and builds controls.
     */
    updateUI() {
        const totalItems = this.allItems.length;
        const totalPages = Math.ceil(totalItems / this.itemsPerPage);

        // Ensure current page is valid
        if (this.currentPage > totalPages) this.currentPage = totalPages || 1;
        if (this.currentPage < 1) this.currentPage = 1;

        // Slice data
        const start = (this.currentPage - 1) * this.itemsPerPage;
        const end = start + this.itemsPerPage;
        const paginatedItems = this.allItems.slice(start, end);

        // Trigger the User's Render Function
        this.onRender(paginatedItems);

        // Render Control Buttons
        this.renderControls(totalItems, totalPages);
    }

    /**
     * Renders the Bootstrap pagination controls into the container.
     */
    renderControls(totalItems, totalPages) {
        const container = document.getElementById(this.containerId);
        if (!container) return;

        if (totalItems === 0) {
            container.innerHTML = '';
            return;
        }

        let html = `
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mt-3 p-2 bg-light rounded-3 shadow-sm border border-light">
            <div class="d-flex align-items-center">
                <span class="text-muted small me-2">Show</span>
                <select class="form-select form-select-sm" style="width: 70px;" id="${this.containerId}-perPage">
                    <option value="5" ${this.itemsPerPage === 5 ? 'selected' : ''}>5</option>
                    <option value="10" ${this.itemsPerPage === 10 ? 'selected' : ''}>10</option>
                    <option value="25" ${this.itemsPerPage === 25 ? 'selected' : ''}>25</option>
                    <option value="50" ${this.itemsPerPage === 50 ? 'selected' : ''}>50</option>
                </select>
                <span class="text-muted small ms-2">entries</span>
            </div>
            
            <div class="d-flex align-items-center">
                <span class="text-muted small me-3">
                    Showing ${(this.currentPage - 1) * this.itemsPerPage + 1} to ${Math.min(this.currentPage * this.itemsPerPage, totalItems)} of ${totalItems}
                </span>

                <nav aria-label="Page navigation">
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item ${this.currentPage === 1 ? 'disabled' : ''}">
                            <button class="page-link border-0 rounded-start" onclick="window['${this.containerId}_instance'].prevPage()"><i class="fas fa-chevron-left"></i></button>
                        </li>
        `;

        // Page Numbers Logic (Smart Display: 1, 2, ..., 5, 6, 7, ..., 10)
        // Simplified for robustness: Show all if < 7 pages, else start/end/middle

        const maxVisibleButtons = 5;
        let startPage = Math.max(1, this.currentPage - Math.floor(maxVisibleButtons / 2));
        let endPage = Math.min(totalPages, startPage + maxVisibleButtons - 1);

        if (endPage - startPage + 1 < maxVisibleButtons) {
            startPage = Math.max(1, endPage - maxVisibleButtons + 1);
        }

        if (startPage > 1) {
            html += `<li class="page-item"><button class="page-link border-0" onclick="window['${this.containerId}_instance'].gotoPage(1)">1</button></li>`;
            if (startPage > 2) html += `<li class="page-item disabled"><span class="page-link border-0">...</span></li>`;
        }

        for (let i = startPage; i <= endPage; i++) {
            const isActive = i === this.currentPage;
            html += `
                <li class="page-item ${isActive ? 'active' : ''}">
                    <button class="page-link border-0 ${isActive ? 'bg-primary text-white shadow-sm' : ''}" onclick="window['${this.containerId}_instance'].gotoPage(${i})">${i}</button>
                </li>
            `;
        }

        if (endPage < totalPages) {
            if (endPage < totalPages - 1) html += `<li class="page-item disabled"><span class="page-link border-0">...</span></li>`;
            html += `<li class="page-item"><button class="page-link border-0" onclick="window['${this.containerId}_instance'].gotoPage(${totalPages})">${totalPages}</button></li>`;
        }

        html += `
                        <li class="page-item ${this.currentPage === totalPages ? 'disabled' : ''}">
                            <button class="page-link border-0 rounded-end" onclick="window['${this.containerId}_instance'].nextPage()"><i class="fas fa-chevron-right"></i></button>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
        `;

        container.innerHTML = html;

        // Bind Per Page Change Event
        const select = document.getElementById(`${this.containerId}-perPage`);
        if (select) {
            select.addEventListener('change', (e) => {
                this.itemsPerPage = parseInt(e.target.value);
                this.currentPage = 1;
                this.updateUI();
            });
        }

        // Expose instance globally for onclick handlers (simplest way without complex event binding)
        window[`${this.containerId}_instance`] = this;
    }

    prevPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.updateUI();
        }
    }

    nextPage() {
        const totalPages = Math.ceil(this.allItems.length / this.itemsPerPage);
        if (this.currentPage < totalPages) {
            this.currentPage++;
            this.updateUI();
        }
    }

    gotoPage(page) {
        this.currentPage = page;
        this.updateUI();
    }
}
