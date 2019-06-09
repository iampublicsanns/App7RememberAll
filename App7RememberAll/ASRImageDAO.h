//
//  ASRImageDAO.h
//  App7RememberAll
//
//  Created by Alexander on 08/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#ifndef ASRImageDAO_h
#define ASRImageDAO_h


#import "ASRMOImage+CoreDataClass.h"
//@class ASRMOImage;NSManagedObject;

/**
 * Класс доступа к картинкам в базе данных.
 * */
@interface ASRImageDAO : NSObject

@property (nonatomic, nonnull, readonly) NSPersistentContainer *persistentContainer;

/**
 * Инициализатор
 * @return инстанс
 * */
- (nullable instancetype)initWithContainer:(nonnull NSPersistentContainer *)container;

/*
 * Создать в базе объект нового изображения
 * @return
 * */
- (nonnull ASRMOImage*)createASRMOImage;

/**
 * Получить изображение хранящееся в базе по id
 * @param moid айдишник изображения в базе
 * @return Managed object изображения
 * */
- (nullable ASRMOImage*)getASRMOImageByMOID:(nonnull NSManagedObjectID*)moid;

/**
 * Получить все изображения, сохраненные в бд
 * @return массив managed object'ов
 * */
- (nullable NSArray<ASRMOImage*> *)getASRMOImages;

/*
 * Удалить изображение из базы данных
 * @param moid айдишник изображения для удаления
 * */
- (void)deleteASRMOImageByMOID:(nonnull NSManagedObjectID *)moid;

/*
 * Удалить изображения из базы данных
 * */
- (void)deleteASRMOImages;

/*
 * Сохранить контекст. Нужно вызывать, чтобы сохранить изменения, внесенные остальными методами этого класса.
 * */
- (void)saveContext;

@end

#endif /* ASRImageDAO_h */
