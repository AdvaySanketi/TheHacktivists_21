

export default async function handler(req, res) {

  if (req.method === 'GET') {

    try {
        console.log('rfvrvrvrvr');
        const db_data = {
            "data":{
                "total_users": {
                    "value":11580,
                    "percentage":-5.9
                },
                "total_orders": {
                    "value":45580,
                    "percentage":10.9
                },
                "total_vendors": {
                    "value":8580,
                    "percentage":-5.9
                },
                "total_earnings": {
                    "value":51580,
                    "percentage":5.9
                },
                "revenue_data": [
                    {
                        "month": "January",
                        "revenue": 18000
                    },
                    {
                        "month": "February",
                        "revenue": 15000
                    },
                    {
                        "month": "March",
                        "revenue": 10000
                    },
                    {
                        "month": "April",
                        "revenue": 12000
                    },
                    {
                        "month": "May",
                        "revenue": 11000
                    },
                    {
                        "month": "June",
                        "revenue": 13000
                    },
                    {
                        "month": "July",
                        "revenue": 12000
                    },
                    {
                        "month": "August",
                        "revenue": 15000
                    },
                    {
                        "month": "September",
                        "revenue": 14000
                    }
                ]
            }
        }

      return res.status(200).json({ db_data });
    } catch (error) {
      return res.status(401).json({ message: 'Invalid or expired token' });
    }
  } else {
    res.status(405).json({ message: 'Method not allowed' });
  }
}
