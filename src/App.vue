<template>
  <div id="app">
    <nav class="navbar navbar-dark navbar-expand-md">
      <router-link class="navbar-brand" to="/">CryptoTunes <span class="text-danger">(TESTNET)</span></router-link>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav">
          <li class="nav-item">
            <router-link class="nav-link" to="/library">My Library</router-link>
          </li>
          <li class="nav-item">
            <router-link class="nav-link" to="/tunes">Latest Tunes</router-link>
          </li>
          <li class="nav-item">
            <router-link class="nav-link" to="/wtf">WTF</router-link>
          </li>
        </ul>
      </div>
    </nav>
    <main role="main">
      <div class="container">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
          <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
          <h4 class="alert-heading">TESTNET Alert!</h4>
          <p>The CryptoTunes smart contract is deployed to the Ropsten Test Net.  With enough interest, CryptoTunes will go live.  Show your interest by donating Ether to 0xafe1cf2909d34f843b510edb9b8ba8f8f8bce854 or contributing on GitHub: <a href="https://github.com/CryptoTunes/source" target="_blank"><font-awesome-icon :icon="fa.github()"></font-awesome-icon></a></p>
        </div>
      </div>
      <router-view :key="$route.name + ($route.params.address || '')"/>
    </main>
    <footer class="footer">
      <div class="container">
        <div class="row">
          <div class="col col-12">
            <span clas="text-muted">&copy; 2018 CryptoTunes</span>
            <a href="https://github.com/CryptoTunes"><font-awesome-icon :icon="fa.github()"></font-awesome-icon></a>
          </div>
        </div>
      </div>
    </footer>
    <favorite-modal></favorite-modal>
  </div>
</template>

<script>
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'
import TruffleContract from 'truffle-contract'
import CtJSON from '../build/contracts/CryptoTunes.json'
import FavoriteModal from '@/components/FavoriteModal'
import EventBus from '@/helpers/EventBus'
import FaHelper from '@/helpers/FaHelper'

export default {
  name: 'App',
  components: { FontAwesomeIcon, FavoriteModal },
  data () {
    return {
      account: null,
      ctContract: null,
      myFavorites: []
    }
  },
  created () {
    const vm = this
    this.initAccount()
    this.initContract()
    this.getMyFavorites()
    setInterval(() => {
      this.initAccount()
    }, 2000)

    EventBus.$on('favorite', tuneId => {
      this.myFavorites.push(tuneId)
    })
    EventBus.$on('account-changed', () => {
      if (this.$web3) {
        vm.getMyFavorites()
      }
    })
  },
  watch: {
    'account': (acct) => {
      EventBus.$emit('account-changed')
    }
  },
  computed: {
    fa () {
      return FaHelper
    }
  },
  methods: {
    initAccount () {
      const vm = this
      return this.$web3.eth.getAccounts((err, accounts) => {
        if (err) {
          console.error(err)
        } else {
          // console.info('accounts => ', accounts)
          vm.account = accounts[0]
        }
      })
    },
    initContract () {
      // console.info(CtJSON)
      this.ctContract = TruffleContract(CtJSON)
      this.ctContract.setProvider(this.$web3.currentProvider)
    },
    getMyFavorites () {
      const vm = this
      if (this.account) {
        this.ctContract.deployed()
          .then(instance => {
            return instance.getMyFavorites({from: this.account})
          })
          .then(res => {
            vm.myFavorites = JSON.parse(JSON.stringify(res))
          })
          .catch(err => {
            console.error(err)
          })
      }
    }
  }
}
</script>

<style lang="scss">
@import 'assets/scss/custom.scss';

html {
  position: relative;
  min-height: 100%;
}
body {
  margin-bottom: 60px;
}
.footer {
  position: absolute;
  bottom: 0;
  width: 100%;
  height: 60px;
  line-height: 60px;
}

</style>
