import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
	static targets = ["profile", "backdrop"]

	connect() {
		this.body = document.body
		console.log("connecting to controller")

	}

	open() {
		this.profileTarget.classList.remove("translate-x-full")
		this.profileTarget.classList.add("translate-x-0")

		this.backdropTarget.classList.remove("hidden", "opacity-0")
		this.backdropTarget.classList.add("opacity-100")

		this.body.style.overflow = "hidden"
	}

	close() {
		this.profileTarget.classList.add("translate-x-full")
		this.profileTarget.classList.remove("translate-x-0")

		this.backdropTarget.classList.add("opacity-0")
		setTimeout(() => {
			this.backdropTarget.classList.add("hidden")
		}, 300)

		this.body.style.overflow = ""
	}
}
