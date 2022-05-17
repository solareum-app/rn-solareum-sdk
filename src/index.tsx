import { NativeModules, Platform,DeviceEventEmitter,
  NativeEventEmitter } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-solareum-sdk' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';



  const EventEmitter = NativeModules.EventEmitter;


let eventEmitter = new NativeEventEmitter(EventEmitter);

const SolareumSdk = NativeModules.SolareumSdk
  ? {...NativeModules.SolareumSdk,
    subscribe: ({handleEvent} :any) => {
    if (Platform.OS === 'ios') {
      console.log("ios")
     eventEmitter.addListener("showEvent", (event: any) => {
        handleEvent(event);
        console.log("🎉 event ",event)
      } )
    } else {
      DeviceEventEmitter.addListener('showEvent', (event: any) => {
        const json = JSON.parse(event);
        handleEvent(json);
      } );
    }
  },
}
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );
  
export default SolareumSdk
