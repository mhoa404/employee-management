import * as bcrypt from 'bcryptjs';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';

import { RegisterUserDto } from './dto/register-user.dto';
import { CompleteProfileDto } from './dto/complete-profile.dto';
import { UserDetails } from 'src/entities/user-details.entity';
import { User } from '../entities/user.entity';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,

    @InjectRepository(UserDetails)
    private userDetailsRepository: Repository<UserDetails>,
    
    private jwtService: JwtService,
  ) {}

  async validateUser(email: string, pwd: string): Promise<User | null> {
    const user = await this.userRepository.findOne({ where: { email }, relations: ['details'] }); // Lấy thông tin từ bảng user-details
    if (!user) return null;
    const isMatch = await bcrypt.compare(pwd, user.pwd);
    if (!isMatch) return null;
    return user;
  }

  generateToken(user: { id: number; email: string; role: string }) {
    const payload = { sub: user.id, email: user.email, role: user.role };
    return this.jwtService.sign(payload);
  }

  async login(email: string, pwd: string) {
    if (!email || !pwd) {
      return { message: 'Please fill in all required fields', data: null, status: 400 };
    }
    const user = await this.validateUser(email, pwd);
    if (!user) {
      return { message: 'Invalid email or password', data: null, status: 401 };
    }
    const token = this.generateToken({
      id: user.id,
      email: user.email,
      role: user.details?.role || 'USER',
    });

    return {
      message: 'Login successful',
      data: {
        token,
        user: {
          id: user.id,
          email: user.email,
          is_complete: user.is_complete,
          role: user.details?.role || 'USER',
        },
      },
      status: 200,
    };
  }

  async completeProfile(userId: number, detailsDto: CompleteProfileDto) {
    const { full_name, phone, department } = detailsDto;

    if (!full_name || !phone || !department) {
      return { message: 'Please fill in all required fields', data: null, status: 400 };
    }
    if (full_name.length > 50) {
      return { message: 'Name is too long', data: null, status: 400 };
    }
    const phoneRegex = /^0\d{9,10}$/;
    if (!phoneRegex.test(phone)) {
      return { message: 'Invalid phone number format', data: null, status: 400 };
    }

    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      return { message: 'User not found', data: null, status: 404 };
    }

    const userDetails = this.userDetailsRepository.create({
      full_name,
      phone,
      department,
      user,
    });
    await this.userDetailsRepository.save(userDetails);

    user.is_complete = true;
    const updatedUser = await this.userRepository.save(user);

    return {
      message: 'Profile updated successfully',
      data: updatedUser,
      status: 200,
    };
  }

  async register(registerUserDto: RegisterUserDto) {
    const { email, pwd, confirm_pwd } = registerUserDto;

    if (!email || !pwd || !confirm_pwd) {
      return { success: false, message: 'Please fill in all required fields', data: null, status: 400 };
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return { success: false, message: 'Invalid email format', data: null, status: 400 };
    }

    if (pwd.length < 6) {
      return { success: false, message: 'Password must be at least 6 characters long', data: null, status: 400 };
    }

    if (pwd !== confirm_pwd) {
      return { success: false, message: 'Passwords do not match', data: null, status: 400 };
    }

    const hashedPwd = await bcrypt.hash(pwd, 10);
    const user = this.userRepository.create({
      email,
      pwd: hashedPwd,
      is_complete: false,
    });
    const savedUser = await this.userRepository.save(user);

    return {
      success: true,
      message: 'User registered successfully',
      data: savedUser,
      status: 201,
    };
  }

  async getUserById(id: number): Promise<User> {
    const user = await this.userRepository.findOne({
      where: { id },
      relations: ['details'], // Bao gồm thông tin từ bảng user-details
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }
    return user;
  }
}
