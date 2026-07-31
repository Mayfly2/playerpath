import { IsString, IsInt, IsDecimal, IsBoolean, IsOptional, IsEmail, Min, Max } from 'class-validator';

export class CreateClubProfileDto {
  @IsString()
  clubName: string;

  @IsOptional() @IsString()
  league?: string;

  @IsOptional() @IsInt() @Min(1) @Max(7)
  step?: number;

  @IsOptional() @IsString()
  ground?: string;

  @IsOptional() @IsString()
  managerName?: string;

  @IsOptional() @IsString()
  assistantManagerName?: string;

  @IsOptional() @IsDecimal()
  locationLat?: number;

  @IsOptional() @IsDecimal()
  locationLng?: number;

  @IsOptional() @IsString()
  description?: string;

  @IsOptional() @IsString()
  philosophy?: string;

  @IsOptional() @IsString()
  facilities?: string;

  @IsOptional() @IsString()
  website?: string;

  @IsOptional() @IsString()
  facebookUrl?: string;

  @IsOptional() @IsString()
  twitterUrl?: string;

  @IsOptional() @IsString()
  instagramUrl?: string;

  @IsOptional() @IsEmail()
  contactEmail?: string;

  @IsOptional() @IsString()
  contactPhone?: string;

  @IsOptional() @IsString()
  trainingDays?: string;

  @IsOptional() @IsString()
  matchDays?: string;

  @IsOptional() @IsInt() @Min(0)
  playersWanted?: number;

  @IsOptional() @IsString()
  budget?: string;

  @IsOptional() @IsBoolean()
  hasOpenTrials?: boolean;
}

export class UpdateClubProfileDto extends CreateClubProfileDto {}
