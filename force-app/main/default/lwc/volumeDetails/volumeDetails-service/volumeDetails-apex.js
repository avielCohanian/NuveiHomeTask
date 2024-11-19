import averageMonthlyVolume from '@salesforce/apex/AccountController.AverageMonthlyVolume'


const getVolumesByAccount = async (accId, daysAgo) => {
    try {
        const res = await averageMonthlyVolume({ accountId: accId, daysAgo: daysAgo || null, isUpdate: false })
        console.log('%c getVolumesByAccount Res', 'color: green; font-weight: bold', JSON.parse(res))
        return JSON.parse(res);
    } catch (err) {
        console.error('%c getVolumesByAccount Err', 'color: red; font-weight: bold', err)
        return null;
    }
}


export default { getVolumesByAccount }