import { LightningElement, wire } from 'lwc';
import fetchLimits from '@salesforce/apex/dynamicOrgLimitsAnalyserController.fetchLimits';

export default class DynamicOrgLimitsAnalyser extends LightningElement {

    limitsData;
    event;


    @wire(fetchLimits)
    getLimits({error, data}){
        if(data){
            this.limitsData = data;
            this.event = setTimeout(() => {
                this.changeColor();
            }, 50);
        }
        if(error){
            console.log('Error fetching Limits in wire: '+error);
        }
    }

    changeColor(){
        this.template.querySelectorAll('.slds-progress-bar__value').forEach(element => {
            if (element.title == 0) {
                element.parentElement.parentElement.parentElement.parentElement.style = "display: none";
            }
            else {
                let width;
                if(element.title > 100)
                    width = 'width: 100%';
                else
                    width = 'width: '+element.title+'%';
                element.style = width;
                if (element.title > 90) {
                    element.style = width + ";background-color: red;";
                }
                else if (element.title > 60) {
                    element.style = width + ";background-color: orange;";
                }
                else if (element.title > 30) {
                    element.style = width + ";background-color: yellow;";
                }
                else{
                    element.style = width + ";background-color: green;";
                }
            }
        });
        clearTimeout(this.event);
    }

}