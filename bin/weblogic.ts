#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { VpcStack } from '../lib/vpc-stack';
import { WeblogicStack } from '../lib/weblogic-stack';

const env = { 
  region: process.env.CDK_DEFAULT_REGION,
  account: process.env.CDK_DEFAULT_ACCOUNT
};

const app = new cdk.App();
const vpc = new VpcStack(
  app, 
  'weblogic-vpc', 
  { env })
  .vpc;
  
new WeblogicStack(app, 'weblogic', { env, vpc });
