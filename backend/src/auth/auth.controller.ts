// backend/src/auth/auth.controller.ts
import { Controller, Post, Body, Param, Get, Request, UseGuards, HttpCode } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginUserDto } from './dto/login-user.dto';
import { RegisterUserDto } from './dto/register-user.dto';
import { CompleteProfileDto } from './dto/complete-profile.dto';
import { JwtAuthGuard } from './jwt-auth.guard';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('login')
  @HttpCode(200)
  async login(@Body() loginUserDto: LoginUserDto) {
    return this.authService.login(loginUserDto.email, loginUserDto.pwd);
  }
  
  @Post('register')
  async register(@Body() registerUserDto: RegisterUserDto) {
    return this.authService.register(registerUserDto);
  }
  
  @Post('complete-profile/:id')
  @HttpCode(200)
  async completeProfile(@Param('id') id: number, @Body() detailsDto: CompleteProfileDto) {
    return this.authService.completeProfile(id, detailsDto);
  }
  
  @UseGuards(JwtAuthGuard)
  @Get('check-auth')
  async checkAuth(@Request() req) {
    return { isAuthenticated: true };
  }

  @UseGuards(JwtAuthGuard)
  @Get('current-user')
  async currentUser(@Request() req) {
    const userId = req.user.userId;
    const user = await this.authService.getUserById(userId);
    if (user) {
      return { user };
    } else {
      return { message: 'User not found' };
    }
  }
}
