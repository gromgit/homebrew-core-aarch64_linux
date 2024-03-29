class Cf4ocl < Formula
  desc "C Framework for OpenCL"
  homepage "https://nunofachada.github.io/cf4ocl/"
  url "https://github.com/nunofachada/cf4ocl/archive/v2.1.0.tar.gz"
  sha256 "662c2cc4e035da3e0663be54efaab1c7fedc637955a563a85c332ac195d72cfa"
  license "LGPL-3.0"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cf4ocl"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b36b4fbf048ce174ad0cf8126706c3e52d67d22a3cc835f9e9e91a00526b69b1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "ocl-icd"
    depends_on "pocl"
  end

  # Fix build failure on Linux caused by undefined Windows-only constants.
  # Upstreamed here: https://github.com/nunofachada/cf4ocl/pull/40
  patch :DATA

  def install
    args = *std_cmake_args
    args << "-DBUILD_TESTS=OFF"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"ccl_devinfo"
  end
end

__END__
diff --git a/src/lib/ccl_event_wrapper.c b/src/lib/ccl_event_wrapper.c
index 0bfbf8a..0ba8bf9 100644
--- a/src/lib/ccl_event_wrapper.c
+++ b/src/lib/ccl_event_wrapper.c
@@ -282,6 +282,7 @@ const char* ccl_event_get_final_name(CCLEvent* evt) {
 			case CL_COMMAND_GL_FENCE_SYNC_OBJECT_KHR:
 				final_name = "GL_FENCE_SYNC_OBJECT_KHR";
 				break;
+            #if defined(__MSC_VER)
 			case CL_COMMAND_ACQUIRE_D3D10_OBJECTS_KHR:
 				final_name = "ACQUIRE_D3D10_OBJECTS_KHR";
 				break;
@@ -300,6 +301,7 @@ const char* ccl_event_get_final_name(CCLEvent* evt) {
 			case CL_COMMAND_RELEASE_D3D11_OBJECTS_KHR:
 				final_name = "RELEASE_D3D11_OBJECTS_KHR";
 				break;
+            #endif
 			case CL_COMMAND_ACQUIRE_EGL_OBJECTS_KHR:
 				final_name = "ACQUIRE_EGL_OBJECTS_KHR";
 				break;
diff --git a/src/lib/ccl_oclversions.h b/src/lib/ccl_oclversions.h
index 4e82c9f..598a7e6 100644
--- a/src/lib/ccl_oclversions.h
+++ b/src/lib/ccl_oclversions.h
@@ -33,7 +33,7 @@
 	#include <OpenCL/opencl.h>
 #else
 	#include <CL/opencl.h>
-	#ifdef CL_VERSION_1_2
+	#if defined(CL_VERSION_1_2) && defined(__MSC_VER)
 		#include <CL/cl_dx9_media_sharing.h>
 	#endif
 #endif
