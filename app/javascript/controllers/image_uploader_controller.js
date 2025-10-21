import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["dropZone", "fileInput", "preview"];

	connect() {
		// Click to open file input
		this.dropZoneTarget.addEventListener("click", () => this.fileInputTarget.click());

		// Handle file selection
		this.fileInputTarget.addEventListener("change", (e) => this.handleFiles(e.target.files));
	}

	handleFiles(files) {
		if (!files[0]) return;

		// Clear previous preview
		this.dropZoneTarget.innerHTML = "";

		const reader = new FileReader();
		reader.onload = (e) => {
			const img = document.createElement("img");
			img.src = e?.target.result;
			img.classList.add("preview-image");
			this.dropZoneTarget.appendChild(img);
		};
		reader.readAsDataURL(files[0]);
	}
}
