#!/bin/bash

# If your system java is not java8 and not use `-vm` like here, will cause
# org.eclipse.e4.core.di.InjectionException: java.lang.NoClassDefFoundError: javax/annotation/PostConstruct

./eclipse/eclipse -vm jre/bin
