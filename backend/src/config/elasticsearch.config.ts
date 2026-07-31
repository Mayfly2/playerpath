import { ConfigService } from '@nestjs/config';

export const elasticsearchConfig = (config: ConfigService) => ({
  node: config.get('ELASTICSEARCH_NODE', 'http://localhost:9200'),
  auth: {
    username: config.get('ELASTICSEARCH_USERNAME', ''),
    password: config.get('ELASTICSEARCH_PASSWORD', ''),
  },
});
