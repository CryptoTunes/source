/* global web3 */
/* eslint no-undef: ["error", { "typeof": true }] */
// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import 'bootstrap/dist/js/bootstrap'
import 'jquery-knob'
import Web3 from 'web3'

Vue.config.productionTip = false

window.addEventListener('load', () => {
  if (typeof web3 !== 'undefined') {
    Vue.prototype.$web3 = new Web3(web3.currentProvider)
  } else {
    console.error('no web3')
    Vue.prototype.$web3 = null
  }
  /* eslint-disable no-new */
  new Vue({
    el: '#app',
    router,
    components: { App },
    template: '<App/>'
  })
})
