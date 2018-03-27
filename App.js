/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  Modal,
  NativeModules,
  DeviceEventEmitter,
  NativeEventEmitter,
  AppState
} from 'react-native';
import SDKComponent from './SDKComponent'

let Pollfish = NativeModules.PollfishModule;
let HyprMediate = NativeModules.HyprMediateModule;

export default class App extends Component {
  state= {
    modalVisible: false
  }

closeModal = () => {
	this.setState({modalVisible: false})
}

componentDidMount(){
  Pollfish.initialize("e87bf486-712b-40ec-a6c0-d3ed6b5649a9", 0, 4, true)
  Pollfish.hide();
  HyprMediate.initializeWithDefaultUserId("a283f955-6080-4682-a0e1-09bcc9578df5")
  // console.log('checkinventory', HyprMediate.checkInventory())
}

componentWillMount(){
  //Pollfish events handlers
  const pollfishEvent = new NativeEventEmitter(Pollfish);
  this.pollfishOpenSub = pollfishEvent.addListener('PollfishOpened', this.pollfishOpenHandler);
  this.pollfishCloseSub = pollfishEvent.addListener('PollfishClosed', this.pollfishCloseHandler);
  this.pollfishCompletedSub = pollfishEvent.addListener('PollfishCompleted', this.pollfishCompletedHandler);
  this.pollfishReceivedSub = pollfishEvent.addListener('PollfishReceived', this.pollfishReceivedHandler);
  this.pollfishNotAvailableSub = pollfishEvent.addListener('PollfishNotAvailable', this.pollfishNotAvailableHandler);
  this.pollfishUsernotEligibleSub = pollfishEvent.addListener('PollfishUsernotEligible', this.pollfishUsernotEligibleHandler);
  
  //HyprMediate events handlers
  const hyprMediateEvent = new NativeEventEmitter(HyprMediate);
  this.hyprMediateCanShowAd = hyprMediateEvent.addListener('HyprMediateCanShowAd', this.hyprMediateCanShowAd);
  this.hyprMediateRewardDelivered = hyprMediateEvent.addListener('HyprMediateRewardDelivered', this.hyprMediateRewardDelivered);
  this.hyprMediateAdStarted = hyprMediateEvent.addListener('HyprMediateAdStarted', this.hyprMediateAdStarted);
  this.hyprMediateAdFinished = hyprMediateEvent.addListener('HyprMediateAdFinished', this.hyprMediateAdFinished);
  this.hyprMediateInitializationComplete = hyprMediateEvent.addListener('HyprMediateInitializationComplete', this.hyprMediateInitializationComplete);
  this.hyprMediateErrorOccurred = hyprMediateEvent.addListener('HyprMediateErrorOccurred', this.hyprMediateErrorOccurred);
  
  }
  
  componentWillUnmount(){
    //remove all pollfish listeners
    this.pollfishOpenSub.remove();
    this.pollfishCloseSub.remove();
    this.pollfishCompletedSub.remove();
    this.pollfishReceivedSub.remove();
    this.pollfishNotAvailableSub.remove();
    this.pollfishUsernotEligibleSub.remove();
    // // remove all hypr listeners
    this.hyprMediateCanShowAd.remove();
    this.hyprMediateRewardDelivered.remove();
    this.hyprMediateAdStarted.remove();
    this.hyprMediateAdFinished.remove();
    this.hyprMediateInitializationComplete.remove();
    this.hyprMediateErrorOccurred.remove();
}

pollfishOpenHandler = (event) => {
  console.log('event pollfish open', event)
}
pollfishCloseHandler = (event) => {
  console.log('event pollfish close', event)
}
pollfishCompletedHandler = (event) => {
  alert('survey is complete')
  console.log('event survey completed', event)
}
pollfishReceivedHandler = (event) => {
  console.log('event pollfish received', event)
}
pollfishNotAvailableHandler = (event) => {
  console.log('event pollfish available', event)
}
pollfishUsernotEligibleHandler = (event) => {
  console.log('event pollfish user not eligible', event)
}


hyprMediateCanShowAd = (event) => {
  console.log('hypr event can show', event)
}
hyprMediateRewardDelivered = (event) => {
  console.log('hypr event reward delivered', event)
}
hyprMediateAdStarted = (event) => {
  console.log('hypr event started', event)
}
hyprMediateAdFinished = (event) => {
  console.log('hypr event finished', event)
}
hyprMediateInitializationComplete = (event) => {
  console.log('hypr event initialization complete', event)
}
hyprMediateErrorOccurred = (event) => {
  console.log('hypr event error occured', event)
}


  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <TouchableOpacity onPress={()=>{
          Pollfish.show();
          // alert('pollfish')
        }}>
          <Text>Open Pollfish add-on</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={()=>{
          HyprMediate.showAd();
          // alert('Hypermediate');
        }}>
          <Text>Open Custom Component</Text>
        </TouchableOpacity>
	<Modal
	  animationType="fade"
          transparent={false}
          visible={this.state.modalVisible}>
	<SDKComponent closeComponent={this.closeModal}/>
	</Modal>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
