class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "https://bitbucket.org/multicoreware/x265_git"
  url "https://bitbucket.org/multicoreware/x265_git/get/3.5.tar.gz"
  sha256 "5ca3403c08de4716719575ec56c686b1eb55b078c0fe50a064dcf1ac20af1618"
  license "GPL-2.0-only"
  head "https://bitbucket.org/multicoreware/x265_git.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/x265"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d955ee4ccccd10f8c79bfbd4a2b0b17c81d357d392a468f8291c8be17c8d7416"
  end

  depends_on "cmake" => :build
  on_intel do
    depends_on "nasm" => :build
  end

  # https://archlinuxarm.org/packages/aarch64/x265/files/0001-arm-fixes.patch
  # https://developer.arm.com/documentation/101754/0618/armclang-Reference/armclang-Command-line-Options/-mfloat-abi
  # https://developer.arm.com/documentation/101754/0618/armclang-Reference/armclang-Command-line-Options/-mfpu
  patch :DATA

  def linux_aarch64?
    on_arm do
      OS.linux?
    end
  end

  def install
    # Build based off the script at ./build/linux/multilib.sh
    args = std_cmake_args + %W[
      -DEXTRA_LINK_FLAGS=-L.
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    (buildpath/"8bit").mkpath

    unless linux_aarch64?
      args += %w[
        -DLINKED_10BIT=ON
        -DLINKED_12BIT=ON
        -DEXTRA_LIB=x265_main10.a;x265_main12.a
      ]
      high_bit_depth_args = std_cmake_args + %w[
        -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF
        -DENABLE_SHARED=OFF -DENABLE_CLI=OFF
      ]

      mkdir "10bit" do
        system "cmake", buildpath/"source", "-DENABLE_HDR10_PLUS=ON", *high_bit_depth_args
        system "make"
        mv "libx265.a", buildpath/"8bit/libx265_main10.a"
      end

      mkdir "12bit" do
        system "cmake", buildpath/"source", "-DMAIN12=ON", *high_bit_depth_args
        system "make"
        mv "libx265.a", buildpath/"8bit/libx265_main12.a"
      end
    end

    cd "8bit" do
      system "cmake", buildpath/"source", *args
      system "make"
      mv "libx265.a", "libx265_main.a"

      if OS.mac?
        system "libtool", "-static", "-o", "libx265.a", "libx265_main.a",
                          "libx265_main10.a", "libx265_main12.a"
      else
        libs = %w[libx265_main.a]
        libs += %w[libx265_main10.a libx265_main12.a] unless linux_aarch64?
        system "ar", "cr", "libx265.a", *libs
        system "ranlib", "libx265.a"
      end

      system "make", "install"
    end
  end

  test do
    yuv_path = testpath/"raw.yuv"
    x265_path = testpath/"x265.265"
    yuv_path.binwrite "\xCO\xFF\xEE" * 3200
    system bin/"x265", "--input-res", "80x80", "--fps", "1", yuv_path, x265_path
    header = "AAAAAUABDAH//w=="
    assert_equal header.unpack("m"), [x265_path.read(10)]
  end
end
__END__
diff --git a/source/CMakeLists.txt b/source/CMakeLists.txt
index a407271b4..bfcd11f05 100755
--- a/source/CMakeLists.txt
+++ b/source/CMakeLists.txt
@@ -76,8 +76,8 @@ elseif(ARMMATCH GREATER "-1")
         set(ARM64 1)
         add_definitions(-DX265_ARCH_ARM=1 -DX265_ARCH_ARM64=1 -DHAVE_ARMV6=0)
     else()
-        message(STATUS "Detected ARM target processor")
-        add_definitions(-DX265_ARCH_ARM=1 -DX265_ARCH_ARM64=0 -DHAVE_ARMV6=1)
+        message(STATUS "Detected ARMV7 system processor")
+        add_definitions(-DX265_ARCH_ARM=1 -DX265_ARCH_ARM64=0 -DHAVE_ARMV6=0 -DHAVE_NEON=1 -fPIC)
     endif()
 else()
     message(STATUS "CMAKE_SYSTEM_PROCESSOR value `${CMAKE_SYSTEM_PROCESSOR}` is unknown")
@@ -238,28 +238,11 @@ if(GCC)
             endif()
         endif()
     endif()
-    if(ARM AND CROSS_COMPILE_ARM)
-        if(ARM64)
-            set(ARM_ARGS -fPIC)
-        else()
-            set(ARM_ARGS -march=armv6 -mfloat-abi=soft -mfpu=vfp -marm -fPIC)
-        endif()
-        message(STATUS "cross compile arm")
-    elseif(ARM)
-        if(ARM64)
-            set(ARM_ARGS -fPIC)
-            add_definitions(-DHAVE_NEON)
-        else()
-            find_package(Neon)
-            if(CPU_HAS_NEON)
-                set(ARM_ARGS -mcpu=native -mfloat-abi=hard -mfpu=neon -marm -fPIC)
-                add_definitions(-DHAVE_NEON)
-            else()
-                set(ARM_ARGS -mcpu=native -mfloat-abi=hard -mfpu=vfp -marm)
-            endif()
-        endif()
+    if(ARM64)
+        set(ARM_ARGS -fPIC)
+        add_definitions(-DHAVE_NEON)
+        add_definitions(${ARM_ARGS})
     endif()
-    add_definitions(${ARM_ARGS})
     if(FPROFILE_GENERATE)
         if(INTEL_CXX)
             add_definitions(-prof-gen -prof-dir="${CMAKE_CURRENT_BINARY_DIR}")

--- a/source/dynamicHDR10/CMakeLists.txt	2021-03-16 19:38:49.000000000 +0800
+++ b/source/dynamicHDR10/CMakeLists.txt	2023-01-08 18:14:44.972791969 +0800
@@ -42,18 +42,11 @@
             endif()
         endif()
     endif()
-    if(ARM AND CROSS_COMPILE_ARM)
-        set(ARM_ARGS -march=armv6 -mfloat-abi=soft -mfpu=vfp -marm -fPIC)
-    elseif(ARM)
-        find_package(Neon)
-        if(CPU_HAS_NEON)
-            set(ARM_ARGS -mcpu=native -mfloat-abi=hard -mfpu=neon -marm -fPIC)
-            add_definitions(-DHAVE_NEON)
-        else()
-            set(ARM_ARGS -mcpu=native -mfloat-abi=hard -mfpu=vfp -marm)
-        endif()
+    if(ARM64)
+        set(ARM_ARGS -fPIC)
+        add_definitions(-DHAVE_NEON)
+        add_definitions(${ARM_ARGS})
     endif()
-    add_definitions(${ARM_ARGS})
     if(FPROFILE_GENERATE)
         if(INTEL_CXX)
             add_definitions(-prof-gen -prof-dir="${CMAKE_CURRENT_BINARY_DIR}")
