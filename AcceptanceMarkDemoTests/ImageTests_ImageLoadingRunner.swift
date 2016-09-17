//
//  ImageTests_ImageLoadingRunner.swift
//  AcceptanceMark
//
//  Created by Andrea Bizzotto on 30/06/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//


class ImageTests_ImageLoadingRunner: ImageTests_ImageLoadingRunnable {

    func run(input: ImageTests_ImageLoadingInput) throws -> ImageTests_ImageLoadingOutput {
        return ImageTests_ImageLoadingOutput(loaded: true)
    }
}
