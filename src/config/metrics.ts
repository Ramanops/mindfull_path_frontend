import * as client from 'prom-client';

client.collectDefaultMetrics();

export const httpRequests = new client.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
});
