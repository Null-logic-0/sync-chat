import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
	static values = {delay: Number}
	static targets = ["input"]


	connect() {
		this.timeout = null
		this.inputTarget.addEventListener("input", () => this.submitForm())

	}

	submitForm() {
		clearTimeout(this.timeout)
		this.timeout = setTimeout(() => {
			this.element.requestSubmit()
		}, this.delayValue || 300)
	}
}
