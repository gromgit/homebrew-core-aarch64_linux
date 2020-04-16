class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/archive/v2.4.1.tar.gz"
  sha256 "3ebbe9a8e67edb4a25890b98c598e9fe23b10f96d1416d6a3ff0732e99d001c1"

  bottle do
    rebuild 1
    sha256 "77fa3ade193f751b7301feae07da4f801adf693ddba02915778c77d142f03311" => :catalina
    sha256 "26209d6086178373e08d8ca6f5acf1c3b49e6896e1fa4eff0c06a3bd91f7b550" => :mojave
    sha256 "9d141246fae66f97b71e864f2c8b7264d5f317380f3872017dc52ea1efd3ea3d" => :high_sierra
  end

  depends_on "cmake" => :build

  # From https://github.com/openexr/openexr/commit/0b26a9dedda4924841323677f1ce0bce37bfbeb4.patch
  patch :DATA

  def install
    cd "IlmBase" do
      system "cmake", ".", *std_cmake_args, "-DBUILD_TESTING=OFF"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~'EOS'
      #include <ImathRoots.h>
      #include <algorithm>
      #include <iostream>

      int main(int argc, char *argv[])
      {
        double x[2] = {0.0, 0.0};
        int n = IMATH_NAMESPACE::solveQuadratic(1.0, 3.0, 2.0, x);

        if (x[0] > x[1])
          std::swap(x[0], x[1]);

        std::cout << n << ", " << x[0] << ", " << x[1] << "\n";
      }
    EOS
    system ENV.cxx, "-I#{include}/OpenEXR", "-o", testpath/"test", "test.cpp"
    assert_equal "2, -2, -1\n", shell_output("./test")
  end
end

__END__
diff --git a/IlmBase/config/CMakeLists.txt b/IlmBase/config/CMakeLists.txt
index 508176a4..a6bff04a 100644
--- a/IlmBase/config/CMakeLists.txt
+++ b/IlmBase/config/CMakeLists.txt
@@ -71,9 +71,9 @@ if(ILMBASE_INSTALL_PKG_CONFIG)
   # use a helper function to avoid variable pollution, but pretty simple
   function(ilmbase_pkg_config_help pcinfile)
     set(prefix ${CMAKE_INSTALL_PREFIX})
-    set(exec_prefix ${CMAKE_INSTALL_BINDIR})
-    set(libdir ${CMAKE_INSTALL_LIBDIR})
-    set(includedir ${CMAKE_INSTALL_INCLUDEDIR})
+    set(exec_prefix "\${prefix}")
+    set(libdir "\${exec_prefix}/${CMAKE_INSTALL_LIBDIR}")
+    set(includedir "\${prefix}/${CMAKE_INSTALL_INCLUDEDIR}")
     set(LIB_SUFFIX_DASH ${ILMBASE_LIB_SUFFIX})
     if(TARGET Threads::Threads)
       # hrm, can't use properties as they end up as generator expressions
