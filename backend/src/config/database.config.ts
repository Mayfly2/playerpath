import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';

export const databaseConfig = (config: ConfigService): TypeOrmModuleOptions => {
  const dbType = config.get('DB_TYPE', 'sqlite');

  if (dbType === 'postgres') {
    return {
      type: 'postgres',
      host: config.get('DB_HOST', 'localhost'),
      port: config.get('DB_PORT', 5432),
      username: config.get('DB_USERNAME', 'playerpath'),
      password: config.get('DB_PASSWORD', 'playerpath'),
      database: config.get('DB_DATABASE', 'playerpath'),
      entities: [__dirname + '/../**/*.entity{.ts,.js}'],
      synchronize: config.get('NODE_ENV') !== 'production',
      migrations: [__dirname + '/../database/migrations/*{.ts,.js}'],
      migrationsRun: config.get('NODE_ENV') === 'production',
      logging: config.get('NODE_ENV') === 'development',
    };
  }

  // Default: SQLite for local dev
  return {
    type: 'better-sqlite3',
    database: config.get('SQLITE_DB_PATH', 'data/playerpath.db'),
    entities: [__dirname + '/../**/*.entity{.ts,.js}'],
    synchronize: true,
    logging: config.get('NODE_ENV') === 'development',
  };
};
