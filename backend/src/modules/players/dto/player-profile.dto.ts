import { IsString, IsInt, IsDecimal, IsEnum, IsBoolean, IsOptional, IsDateString, IsArray, Min, Max } from 'class-validator';
import { PreferredFoot, Availability, Position } from '../entities/player-profile.entity';

export class CreatePlayerProfileDto {
  @IsString()
  fullName: string;

  @IsOptional() @IsDateString()
  dateOfBirth?: string;

  @IsOptional() @IsInt() @Min(100) @Max(250)
  heightCm?: number;

  @IsOptional() @IsDecimal()
  weightKg?: number;

  @IsOptional() @IsEnum(PreferredFoot)
  preferredFoot?: PreferredFoot;

  @IsOptional() @IsString()
  nationality?: string;

  @IsOptional() @IsString()
  bio?: string;

  @IsOptional() @IsDecimal()
  locationLat?: number;

  @IsOptional() @IsDecimal()
  locationLng?: number;

  @IsOptional() @IsInt() @Min(0) @Max(500)
  travelRadiusKm?: number;

  @IsOptional() @IsInt() @Min(1) @Max(7)
  currentStep?: number;

  @IsOptional() @IsInt() @Min(1) @Max(7)
  highestStep?: number;

  @IsOptional() @IsString()
  county?: string;

  @IsOptional() @IsEnum(Availability)
  availability?: Availability;

  @IsOptional() @IsString()
  contractStatus?: string;

  @IsOptional() @IsString()
  workStatus?: string;

  @IsOptional() @IsBoolean()
  hasDrivingLicence?: boolean;

  @IsOptional() @IsBoolean()
  hasOwnTransport?: boolean;

  @IsOptional() @IsBoolean()
  openToTrials?: boolean;

  @IsOptional() @IsBoolean()
  openToMessages?: boolean;

  @IsOptional() @IsBoolean()
  openToAgents?: boolean;

  @IsOptional() @IsString()
  preferredTrainingDays?: string;

  @IsOptional() @IsString()
  preferredMatchDays?: string;

  @IsOptional() @IsString()
  medicalNotes?: string;

  @IsOptional() @IsArray()
  languagesSpoken?: string[];

  @IsOptional() @IsArray()
  lookingForSteps?: string[];
}

export class UpdatePlayerProfileDto extends CreatePlayerProfileDto {}

export class AddPositionDto {
  @IsEnum(Position)
  position: Position;

  @IsBoolean()
  isPrimary: boolean;
}

export class AddStatisticDto {
  @IsString()
  season: string;

  @IsOptional() @IsInt()
  appearances?: number;

  @IsOptional() @IsInt()
  goals?: number;

  @IsOptional() @IsInt()
  assists?: number;

  @IsOptional() @IsInt()
  cleanSheets?: number;

  @IsOptional() @IsInt()
  minutesPlayed?: number;

  @IsOptional() @IsInt()
  yellowCards?: number;

  @IsOptional() @IsInt()
  redCards?: number;
}

export class AddClubHistoryDto {
  @IsString()
  clubName: string;

  @IsString()
  years: string;

  @IsOptional() @IsInt()
  step?: number;

  @IsOptional() @IsString()
  league?: string;
}
