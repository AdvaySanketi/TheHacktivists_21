const uptime = (uptimeInSeconds) => {
    let uptimeMessage
  
    if (uptimeInSeconds < 60) {
      uptimeMessage = `${Math.floor(uptimeInSeconds)} seconds`
    } else if (uptimeInSeconds < 3600) {
      const uptimeInMinutes = uptimeInSeconds / 60
      const remainingSeconds = uptimeInSeconds % 60
      uptimeMessage = `${Math.floor(uptimeInMinutes)} minutes, ${Math.floor(remainingSeconds)} seconds`
    } else if (uptimeInSeconds < 86400) {
      const uptimeInHours = uptimeInSeconds / 3600
      const remainingMinutes = (uptimeInSeconds % 3600) / 60
      uptimeMessage = `${Math.floor(uptimeInHours)} hours, ${Math.floor(remainingMinutes)} minutes`
    } else {
      const uptimeInDays = uptimeInSeconds / 86400
      const remainingHours = (uptimeInSeconds % 86400) / 3600
      const remainingMinutes = (uptimeInSeconds % 3600) / 60
      uptimeMessage = `${Math.floor(uptimeInDays)} days, ${Math.floor(remainingHours)} hours, ${Math.floor(remainingMinutes)} minutes`
    }
    return uptimeMessage
  }
  
  module.exports = uptime