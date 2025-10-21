import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
	static targets = ["menu", "backdrop"]

	connect() {
		this.body = document.body
	}

	open() {
		this.menuTarget.classList.add("translate-x-0")
		this.menuTarget.classList.remove("-translate-x-full")

		this.backdropTarget.classList.remove("hidden", "opacity-0")
		this.backdropTarget.classList.add("opacity-100")

		this.body.style.overflow = "hidden"
	}

	close() {
		this.menuTarget.classList.add("-translate-x-full")
		this.menuTarget.classList.remove("translate-x-0")

		this.backdropTarget.classList.add("opacity-0")
		setTimeout(() => {
			this.backdropTarget.classList.add("hidden")
		}, 300)

		this.body.style.overflow = ""
	}

	handleKeydown(event) {
		if (event.key === "Escape") {
			this.close()
		}
	}
}
