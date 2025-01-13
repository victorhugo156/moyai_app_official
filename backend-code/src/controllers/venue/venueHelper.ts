import { int } from "aws-sdk/clients/datapipeline.js";
import { Venue } from "../../db/entities/Venue.js";
import { AccessibilityStatus } from "../../db/entities/AccessibilityStatus.js";

type AccessibilityMap = {
  mobilityAidOrWalkingChallanging: number;
  getOverwhelemdWithNoiseLights: number;
  haveInvisibleDisability: number;
  haveFoodIntolerance: number;
};

export function mapVenueAccessibilityPercentage(
  venue: Venue
): AccessibilityMap {
  var mobilityAidOrWalkingChallanging = 0;
  var getOverwhelemdWithNoiseLights = 0;
  var haveInvisibleDisability = 0;
  var haveFoodIntolerance = 0;

  if (venue.additionalInformation?.brokenOrMissingInfo != null) {
    mobilityAidOrWalkingChallanging++;
    getOverwhelemdWithNoiseLights++;
    haveInvisibleDisability++;
    haveFoodIntolerance++;
  }
  if (venue.additionalInformation?.venueLiveEvents != null) {
    mobilityAidOrWalkingChallanging++;
    getOverwhelemdWithNoiseLights++;
    haveInvisibleDisability++;
    haveFoodIntolerance++;
  }
  if (venue.additionalInformation?.additionalHelpfulFeatures != null) {
    mobilityAidOrWalkingChallanging++;
    getOverwhelemdWithNoiseLights++;
    haveInvisibleDisability++;
    haveFoodIntolerance++;
  }

  if (venue.additionalInformation?.websiteAccessibility != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.additionalInformation?.websiteFeatures != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.additionalInformation?.otherSocialMedia != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.additionalInformation?.twitterXLink != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.additionalInformation?.facebookLink != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.additionalInformation?.websiteLink != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.additionalInformation?.instagramLink != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }

  if (venue.additionalInformation?.menuUrl != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
    haveFoodIntolerance++;
  }
  if (venue.additionalInformation?.menuImage1 != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
    haveFoodIntolerance++;
  }
  if (venue.additionalInformation?.foodIntoleranceOption != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
    haveFoodIntolerance++;
  }
  if (venue.venueEnvironments?.animalsWelcome != null) {
    haveInvisibleDisability++;
  }
  if (venue.venueEnvironments?.overwhelmManagement != null) {
    getOverwhelemdWithNoiseLights++;
    haveInvisibleDisability++;
  }
  if (venue.venueEnvironments?.imageOfVisualOverwhelm != null) {
    getOverwhelemdWithNoiseLights++;
    haveInvisibleDisability++;
  }
  if (venue.venueEnvironments?.visualStimulation != null) {
    getOverwhelemdWithNoiseLights++;
    haveInvisibleDisability++;
  }
  if (venue.venueEnvironments?.temperature != null) {
    haveInvisibleDisability++;
  }
  if (venue.venueEnvironments?.otherSmells != null) {
    haveInvisibleDisability++;
  }
  if (venue.venueEnvironments?.smell != null) {
    haveInvisibleDisability++;
  }

  if (venue.venueEnvironments?.imageOfServingArea != null) {
    getOverwhelemdWithNoiseLights++;
    haveInvisibleDisability++;
  }
  if (venue.venueEnvironments?.flooring != null) {
    getOverwhelemdWithNoiseLights++;
    haveInvisibleDisability++;
  }
  if (venue.venueEnvironments?.hearingAccessibility != null) {
    haveInvisibleDisability++;
  }
  if (venue.venueEnvironments?.soundCharacteristics != null) {
    getOverwhelemdWithNoiseLights++;
    haveInvisibleDisability++;
  }
  if (venue.venueEnvironments?.timeOfReading != null) {
    getOverwhelemdWithNoiseLights++;
    haveInvisibleDisability++;
  }
  if (venue.venueEnvironments?.recordingDiningAreaSound != null) {
    getOverwhelemdWithNoiseLights++;
    haveInvisibleDisability++;
  }
  if (venue.venueEnvironments?.otherSounds != null) {
    getOverwhelemdWithNoiseLights++;
    haveInvisibleDisability++;
  }
  if (venue.venueEnvironments?.maxDecibelReading != null) {
    getOverwhelemdWithNoiseLights++;
    haveInvisibleDisability++;
  }
  if (venue.venueEnvironments?.avgDecibelReading != null) {
    getOverwhelemdWithNoiseLights++;
    haveInvisibleDisability++;
  }
  if (venue.venueEnvironments?.visualAccessibility != null) {
    getOverwhelemdWithNoiseLights++;
    haveInvisibleDisability++;
  }

  if (venue.venueEnvironments?.imageOfLightning != null) {
    getOverwhelemdWithNoiseLights++;
    haveInvisibleDisability++;
  }

  if (venue.venueEnvironments?.venueLightning != null) {
    getOverwhelemdWithNoiseLights++;
    haveInvisibleDisability++;
  }

  if (venue.toilet?.toiletServiceAreaVideo != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }

  if (venue.toilet?.toiletImage1 != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }

  if (venue.toilet?.accessibilityFeature != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.toilet?.stallDoorToiletClearanceCm != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }

  if (venue.toilet?.floorSpaceInToilet != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }

  if (venue.toilet?.toiletLightning != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }

  if (venue.toilet?.basinHeight != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }

  if (venue.toilet?.railLocation != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }

  if (venue.toilet?.height != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.toilet?.tactileIndicator != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.toilet?.stallDoorwayWidth != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }

  if (venue.toilet?.entryToToilet != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }

  if (venue.toilet?.liftFeatures != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }

  if (venue.toilet?.escalatorType != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.toilet?.stairsImage != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.toilet?.rampImage != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.toilet?.rampFeatures != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.toilet?.accessibilityFeature != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.toilet?.isJourneyToToiletFlat != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.toilet?.distanceToToilet != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.toilet?.toiletUsage != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.toilet?.toiletClassifications != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.toilet?.locationOfToilet != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.accessibility?.tableMeasurements != null) {
    mobilityAidOrWalkingChallanging++;
  }
  if (venue.accessibility?.chairMeasurements != null) {
    mobilityAidOrWalkingChallanging++;
  }
  if (venue.accessibility?.diningAreaImage1 != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.accessibility?.flooring != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.accessibility?.roomToMove != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }

  if (venue.accessibility?.liftImage != null) {
    mobilityAidOrWalkingChallanging++;
  }

  if (venue.accessibility?.liftFeature != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }

  if (venue.accessibility?.rampImage != null) {
    mobilityAidOrWalkingChallanging++;
  }

  if (venue.accessibility?.rampFeature != null) {
    mobilityAidOrWalkingChallanging++;
  }

  if (venue.accessibility?.stairImage != null) {
    mobilityAidOrWalkingChallanging++;
  }

  if (venue.accessibility?.escalatorImage != null) {
    mobilityAidOrWalkingChallanging++;
  }

  if (venue.accessibility?.escalatorType != null) {
    mobilityAidOrWalkingChallanging++;
  }

  if (venue.accessibility?.insideFeatures != null) {
    mobilityAidOrWalkingChallanging++;
  }

  if (venue.frontImageOfBusiness != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }

  if (venue.accessibleParkingAvailable != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.closestAccessibleParking != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }
  if (venue.distanceToClosestAccessibleParking != null) {
    mobilityAidOrWalkingChallanging++;
    haveInvisibleDisability++;
  }

  if (venue.optionsForAccess != null) {
    var mobilityAidOrWalkingChallangingTemp = 0;
    var haveInvisibleDisabilityTemp = 0;

    for (var i = 0; i < venue.optionsForAccess.length; i++) {
      if (venue.optionsForAccess[i].optionForAccess != null) {
        mobilityAidOrWalkingChallangingTemp++;
        haveInvisibleDisabilityTemp++;
      }
      if (venue.optionsForAccess[i].entranceFeatures != null) {
        mobilityAidOrWalkingChallangingTemp++;
        haveInvisibleDisabilityTemp++;
      }
      if (venue.optionsForAccess[i].imageOfRamp != null) {
        mobilityAidOrWalkingChallangingTemp++;
      }
      if (venue.optionsForAccess[i].imageOfStairsForThisAccess != null) {
        mobilityAidOrWalkingChallangingTemp++;
        haveInvisibleDisabilityTemp++;
      }
      if (venue.optionsForAccess[i].liftForThisAccess != null) {
        mobilityAidOrWalkingChallangingTemp++;
      }
      if (venue.optionsForAccess[i].rampFeatures != null) {
        mobilityAidOrWalkingChallangingTemp++;
      }
      if (venue.optionsForAccess[i].featuresOfSteps != null) {
        mobilityAidOrWalkingChallangingTemp++;
      }
      if (venue.optionsForAccess[i].entranceDoorCm != null) {
        mobilityAidOrWalkingChallangingTemp++;
        haveInvisibleDisabilityTemp++;
      }
      if (venue.optionsForAccess[i].liftForThisAccess != null) {
        mobilityAidOrWalkingChallangingTemp++;
      }
      if (venue.optionsForAccess[i].escalatorForThisAccess != null) {
        mobilityAidOrWalkingChallangingTemp++;
      }
      if (venue.optionsForAccess[i].sinageAndDirection != null) {
        mobilityAidOrWalkingChallangingTemp++;
        haveInvisibleDisabilityTemp++;
      }
      if (venue.optionsForAccess[i].obstaclesWithTheAccess != null) {
        mobilityAidOrWalkingChallangingTemp++;
        haveInvisibleDisabilityTemp++;
      }
      if (venue.optionsForAccess[i].otherObstacles != null) {
        mobilityAidOrWalkingChallangingTemp++;
        haveInvisibleDisabilityTemp++;
      }
    }

    if (mobilityAidOrWalkingChallangingTemp > 1)
      mobilityAidOrWalkingChallanging++;

    if (haveInvisibleDisabilityTemp > 1) haveInvisibleDisability++;

    // const perMob = (mobilityAidOrWalkingChallanging / 66) * 100;
    // const perNoiseLight = (getOverwhelemdWithNoiseLights / 17) * 100;
    // const perInv = (haveInvisibleDisability / 70) * 100;
    // const perFood = (haveFoodIntolerance / 6) * 100;
  }

  return {
    mobilityAidOrWalkingChallanging,
    getOverwhelemdWithNoiseLights,
    haveInvisibleDisability,
    haveFoodIntolerance,
  };
}
