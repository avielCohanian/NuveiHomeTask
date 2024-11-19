import { LightningElement, api, track, wire } from 'lwc';

import apexService from './volumeDetails-service/volumeDetails-apex'
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = [
    'Account.AverageMonthlyVolume__c',
    'Account.Tier__c',
];
export default class VolumeDetails extends LightningElement {
    @api recordId;
    @api daysAgo = 365;
    @track accData = { avgVolume: null, tier: '' };
    @track accDetails = {
        name: '', volumeCurrency: 0, avgVolumeCurrency: 0
    }
    isLoading = false;
    debounceTimeout;

    get getCardTitle() {
        return `VOLUME DETAILS📈 ${this.accData.tier}`
    }

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredAccount({ error, data }) {
        if (data) {
            console.log(data.fields?.AverageMonthlyVolume__c?.value);
            const amount = +(data.fields?.AverageMonthlyVolume__c?.value || 0);
            this.accData.avgVolume = `${(+amount.toFixed(2)).toLocaleString('en-US')}$`;
            this.accData.tier = data.fields?.Tier__c?.value;
        } else if (error) {
            console.error(error);
        }
    };

    connectedCallback() {
        this.init();
    }


    async init() {
        this.isLoading = true;
        try {
            const res = await apexService.getVolumesByAccount(this.recordId, this.daysAgo)
            console.log('res', res);

            if (res.accountDetails?.length) {
                const data = res.accountDetails[0];
                this.accDetails = { ...data, volumeCurrency: `${(+(data.volumeCurrency && this.daysAgo ? data.volumeCurrency / this.daysAgo : 0).toFixed(2)).toLocaleString('en-US')}$` }
            }
            console.log('this.accDetails', JSON.parse(JSON.stringify(this.accDetails)));
        } catch (err) {
            console.error('%c init Err', 'color: red; font-weight: bold', err);

        } finally {
            this.isLoading = false;

        }
    }

    updateDays(ev) {
        this.daysAgo = ev.target.value;


        if (this.debounceTimeout)
            clearTimeout(this.debounceTimeout);

        this.debounceTimeout = setTimeout(() => {
            this.init()
        }, 500);


    }

}