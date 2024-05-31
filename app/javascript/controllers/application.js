import { Application } from "@hotwired/stimulus"
import Sortable from '@stimulus-components/sortable'

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

application.register('sortable', Sortable)
