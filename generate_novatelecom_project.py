import os
import uuid

def gen_id():
    return uuid.uuid4().hex[:24].upper()

project_dir = os.path.abspath("/Users/rohit.sampannavar/Desktop/iOS-Apps")
app_dir = os.path.join(project_dir, "NovaTelecom")
tests_dir = os.path.join(project_dir, "NovaTelecomTests")

# Discover all swift files in NovaTelecom
app_sources = []
for root, _, files in os.walk(app_dir):
    for f in sorted(files):
        if f.endswith(".swift"):
            rel_path = os.path.relpath(os.path.join(root, f), app_dir)
            app_sources.append(rel_path)

# Discover app resources
app_resources = [
    "Resources/Assets.xcassets",
]

# Discover test sources
test_sources = []
for root, _, files in os.walk(tests_dir):
    for f in sorted(files):
        if f.endswith(".swift"):
            rel_path = os.path.relpath(os.path.join(root, f), tests_dir)
            test_sources.append(rel_path)

# IDs
proj_id = gen_id()
main_group_id = gen_id()
app_group_id = gen_id()
tests_group_id = gen_id()
products_group_id = gen_id()

app_target_id = gen_id()
tests_target_id = gen_id()

app_product_id = gen_id()
tests_product_id = gen_id()

app_sources_build_phase_id = gen_id()
app_frameworks_build_phase_id = gen_id()
app_resources_build_phase_id = gen_id()

tests_sources_build_phase_id = gen_id()
tests_frameworks_build_phase_id = gen_id()
tests_resources_build_phase_id = gen_id()

target_proxy_id = gen_id()
target_dep_id = gen_id()

app_config_list_id = gen_id()
tests_config_list_id = gen_id()
proj_config_list_id = gen_id()

proj_debug_config_id = gen_id()
proj_release_config_id = gen_id()
app_debug_config_id = gen_id()
app_release_config_id = gen_id()
tests_debug_config_id = gen_id()
tests_release_config_id = gen_id()

build_files = []
file_refs = []
app_build_file_ids = []
app_res_file_ids = []
app_file_ref_ids = []
tests_build_file_ids = []
tests_file_ref_ids = []

for s in app_sources:
    bf_id = gen_id()
    fr_id = gen_id()
    name = os.path.basename(s)
    build_files.append(f'\t\t{bf_id} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {fr_id} /* {name} */; }};')
    file_refs.append(f'\t\t{fr_id} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "{s}"; sourceTree = "<group>"; }};')
    app_build_file_ids.append(bf_id)
    app_file_ref_ids.append(fr_id)

for r in app_resources:
    bf_id = gen_id()
    fr_id = gen_id()
    name = os.path.basename(r)
    file_type = "folder.assetcatalog" if r.endswith(".xcassets") else "text"
    build_files.append(f'\t\t{bf_id} /* {name} in Resources */ = {{isa = PBXBuildFile; fileRef = {fr_id} /* {name} */; }};')
    file_refs.append(f'\t\t{fr_id} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = {file_type}; path = "{r}"; sourceTree = "<group>"; }};')
    app_res_file_ids.append(bf_id)
    app_file_ref_ids.append(fr_id)

info_plist_id = gen_id()
file_refs.append(f'\t\t{info_plist_id} /* Info.plist */ = {{isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = "App/Info.plist"; sourceTree = "<group>"; }};')
app_file_ref_ids.append(info_plist_id)

for t in test_sources:
    bf_id = gen_id()
    fr_id = gen_id()
    name = os.path.basename(t)
    build_files.append(f'\t\t{bf_id} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {fr_id} /* {name} */; }};')
    file_refs.append(f'\t\t{fr_id} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "{t}"; sourceTree = "<group>"; }};')
    tests_build_file_ids.append(bf_id)
    tests_file_ref_ids.append(fr_id)

# Product references
file_refs.append(f'\t\t{app_product_id} /* NovaTelecom.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = NovaTelecom.app; sourceTree = BUILT_PRODUCTS_DIR; }};')
file_refs.append(f'\t\t{tests_product_id} /* NovaTelecomTests.xctest */ = {{isa = PBXFileReference; explicitFileType = wrapper.cfbundle; includeInIndex = 0; path = NovaTelecomTests.xctest; sourceTree = BUILT_PRODUCTS_DIR; }};')

build_files_str = "\n".join(build_files)
file_refs_str = "\n".join(file_refs)
app_children_str = "\n".join([f'\t\t\t\t{fid},' for fid in app_file_ref_ids])
tests_children_str = "\n".join([f'\t\t\t\t{fid},' for fid in tests_file_ref_ids])
app_res_files_str = "\n".join([f'\t\t\t\t{bfid} /* in Resources */,' for bfid in app_res_file_ids])
app_src_files_str = "\n".join([f'\t\t\t\t{bfid} /* in Sources */,' for bfid in app_build_file_ids])
tests_src_files_str = "\n".join([f'\t\t\t\t{bfid} /* in Sources */,' for bfid in tests_build_file_ids])

pbxproj = f"""// !$*UTF8*$!
{{
	archiveVersion = 1;
	classes = {{
	}};
	objectVersion = 56;
	objects = {{

/* Begin PBXBuildFile section */
{build_files_str}
/* End PBXBuildFile section */

/* Begin PBXContainerItemProxy section */
		{target_proxy_id} /* PBXContainerItemProxy */ = {{
			isa = PBXContainerItemProxy;
			containerPortal = {proj_id} /* Project object */;
			proxyType = 1;
			remoteGlobalIDString = {app_target_id};
			remoteInfo = NovaTelecom;
		}};
/* End PBXContainerItemProxy section */

/* Begin PBXFileReference section */
{file_refs_str}
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		{app_frameworks_build_phase_id} /* Frameworks */ = {{
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
		{tests_frameworks_build_phase_id} /* Frameworks */ = {{
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		{main_group_id} = {{
			isa = PBXGroup;
			children = (
				{app_group_id} /* NovaTelecom */,
				{tests_group_id} /* NovaTelecomTests */,
				{products_group_id} /* Products */,
			);
			sourceTree = "<group>";
		}};
		{app_group_id} /* NovaTelecom */ = {{
			isa = PBXGroup;
			children = (
{app_children_str}
			);
			path = NovaTelecom;
			sourceTree = "<group>";
		}};
		{tests_group_id} /* NovaTelecomTests */ = {{
			isa = PBXGroup;
			children = (
{tests_children_str}
			);
			path = NovaTelecomTests;
			sourceTree = "<group>";
		}};
		{products_group_id} /* Products */ = {{
			isa = PBXGroup;
			children = (
				{app_product_id} /* NovaTelecom.app */,
				{tests_product_id} /* NovaTelecomTests.xctest */,
			);
			name = Products;
			sourceTree = "<group>";
		}};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		{app_target_id} /* NovaTelecom */ = {{
			isa = PBXNativeTarget;
			buildConfigurationList = {app_config_list_id} /* Build configuration list for PBXNativeTarget "NovaTelecom" */;
			buildPhases = (
				{app_sources_build_phase_id} /* Sources */,
				{app_frameworks_build_phase_id} /* Frameworks */,
				{app_resources_build_phase_id} /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = NovaTelecom;
			productName = NovaTelecom;
			productReference = {app_product_id} /* NovaTelecom.app */;
			productType = "com.apple.product-type.application";
		}};
		{tests_target_id} /* NovaTelecomTests */ = {{
			isa = PBXNativeTarget;
			buildConfigurationList = {tests_config_list_id} /* Build configuration list for PBXNativeTarget "NovaTelecomTests" */;
			buildPhases = (
				{tests_sources_build_phase_id} /* Sources */,
				{tests_frameworks_build_phase_id} /* Frameworks */,
				{tests_resources_build_phase_id} /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
				{target_dep_id} /* PBXTargetDependency */,
			);
			name = NovaTelecomTests;
			productName = NovaTelecomTests;
			productReference = {tests_product_id} /* NovaTelecomTests.xctest */;
			productType = "com.apple.product-type.bundle.unit-test";
		}};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		{proj_id} /* Project object */ = {{
			isa = PBXProject;
			attributes = {{
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1600;
				LastUpgradeCheck = 1600;
				TargetAttributes = {{
					{app_target_id} = {{
						CreatedOnToolsVersion = 16.0;
					}};
					{tests_target_id} = {{
						CreatedOnToolsVersion = 16.0;
						TestTargetID = {app_target_id};
					}};
				}};
			}};
			buildConfigurationList = {proj_config_list_id} /* Build configuration list for PBXProject "NovaTelecom" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = {main_group_id};
			productRefGroup = {products_group_id} /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				{app_target_id} /* NovaTelecom */,
				{tests_target_id} /* NovaTelecomTests */,
			);
		}};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		{app_resources_build_phase_id} /* Resources */ = {{
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
{app_res_files_str}
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
		{tests_resources_build_phase_id} /* Resources */ = {{
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		{app_sources_build_phase_id} /* Sources */ = {{
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
{app_src_files_str}
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
		{tests_sources_build_phase_id} /* Sources */ = {{
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
{tests_src_files_str}
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXSourcesBuildPhase section */

/* Begin PBXTargetDependency section */
		{target_dep_id} /* PBXTargetDependency */ = {{
			isa = PBXTargetDependency;
			target = {app_target_id} /* NovaTelecom */;
			targetProxy = {target_proxy_id} /* PBXContainerItemProxy */;
		}};
/* End PBXTargetDependency section */

/* Begin XCBuildConfiguration section */
		{proj_debug_config_id} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = NO;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDEFINED_VARIABLES = YES;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG $(inherited)";
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
			}};
			name = Debug;
		}};
		{proj_release_config_id} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = NO;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDEFINED_VARIABLES = YES;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				MTL_ENABLE_DEBUG_INFO = NO;
				MTL_FAST_MATH = YES;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				SWIFT_OPTIMIZATION_LEVEL = "-O";
				VALIDATE_PRODUCT = YES;
			}};
			name = Release;
		}};
		{app_debug_config_id} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS = NO;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_ASSET_PATHS = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = NovaTelecom/App/Info.plist;
				INFOPLIST_KEY_CFBundleDisplayName = "Nova Telecom";
				INFOPLIST_KEY_LSApplicationCategoryType = "public.app-category.utilities";
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.novatelecom.app;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Debug;
		}};
		{app_release_config_id} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS = NO;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_ASSET_PATHS = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = NovaTelecom/App/Info.plist;
				INFOPLIST_KEY_CFBundleDisplayName = "Nova Telecom";
				INFOPLIST_KEY_LSApplicationCategoryType = "public.app-category.utilities";
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.novatelecom.app;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Release;
		}};
		{tests_debug_config_id} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES;
				BUNDLE_LOADER = "$(TEST_HOST)";
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				GENERATE_INFOPLIST_FILE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.novatelecom.appTests;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = NO;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
				TEST_HOST = "$(BUILT_PRODUCTS_DIR)/NovaTelecom.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/NovaTelecom";
			}};
			name = Debug;
		}};
		{tests_release_config_id} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES;
				BUNDLE_LOADER = "$(TEST_HOST)";
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				GENERATE_INFOPLIST_FILE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.novatelecom.appTests;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = NO;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
				TEST_HOST = "$(BUILT_PRODUCTS_DIR)/NovaTelecom.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/NovaTelecom";
			}};
			name = Release;
		}};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		{proj_config_list_id} /* Build configuration list for PBXProject "NovaTelecom" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{proj_debug_config_id} /* Debug */,
				{proj_release_config_id} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
		{app_config_list_id} /* Build configuration list for PBXNativeTarget "NovaTelecom" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{app_debug_config_id} /* Debug */,
				{app_release_config_id} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
		{tests_config_list_id} /* Build configuration list for PBXNativeTarget "NovaTelecomTests" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{tests_debug_config_id} /* Debug */,
				{tests_release_config_id} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
/* End XCConfigurationList section */

	}};
	rootObject = {proj_id} /* Project object */;
}}
"""

os.makedirs(os.path.join(project_dir, "NovaTelecom.xcodeproj"), exist_ok=True)
pbxproj_path = os.path.join(project_dir, "NovaTelecom.xcodeproj", "project.pbxproj")
with open(pbxproj_path, "w") as f:
    f.write(pbxproj)

# Generate Shared Scheme
scheme = f"""<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1600"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "{app_target_id}"
               BuildableName = "NovaTelecom.app"
               BlueprintName = "NovaTelecom"
               ReferencedContainer = "container:NovaTelecom.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "NO"
            buildForProfiling = "NO"
            buildForArchiving = "NO"
            buildForAnalyzing = "NO">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "{tests_target_id}"
               BuildableName = "NovaTelecomTests.xctest"
               BlueprintName = "NovaTelecomTests"
               ReferencedContainer = "container:NovaTelecom.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      shouldUseLaunchSchemeArgsEnv = "YES"
      shouldAutocreateTestPlan = "YES">
      <Testables>
         <TestableReference
            skipped = "NO">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "{tests_target_id}"
               BuildableName = "NovaTelecomTests.xctest"
               BlueprintName = "NovaTelecomTests"
               ReferencedContainer = "container:NovaTelecom.xcodeproj">
            </BuildableReference>
         </TestableReference>
      </Testables>
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "{app_target_id}"
            BuildableName = "NovaTelecom.app"
            BlueprintName = "NovaTelecom"
            ReferencedContainer = "container:NovaTelecom.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "Release"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "{app_target_id}"
            BuildableName = "NovaTelecom.app"
            BlueprintName = "NovaTelecom"
            ReferencedContainer = "container:NovaTelecom.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "Debug">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
"""

schemes_dir = os.path.join(project_dir, "NovaTelecom.xcodeproj", "xcshareddata", "xcschemes")
os.makedirs(schemes_dir, exist_ok=True)
with open(os.path.join(schemes_dir, "NovaTelecom.xcscheme"), "w") as f:
    f.write(scheme)

print(f"Successfully generated NovaTelecom.xcodeproj with {len(app_sources)} app sources and {len(test_sources)} test sources!")
