class GnustepBase < Formula
  desc "Library of general-purpose, non-graphical Objective C objects"
  homepage "https://github.com/gnustep/libs-base"
  url "https://github.com/gnustep/libs-base/releases/download/base-1_28_0/gnustep-base-1.28.0.tar.gz"
  sha256 "c7d7c6e64ac5f5d0a4d5c4369170fc24ed503209e91935eb0e2979d1601039ed"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gnustep-base"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a83f9c266009221883ccaa3b8c3f854b4d303bd8871bf1fb0cd2cf81c359dcf2"
  end

  depends_on "gnustep-make" => :build
  depends_on "gmp"
  depends_on "gnutls"

  # While libobjc2 is built with clang on Linux, it does not use any LLVM runtime libraries.
  uses_from_macos "llvm" => [:build, :test]
  uses_from_macos "icu4c"
  uses_from_macos "libffi"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "libobjc2"
  end

  # Clang must be used on Linux because GCC Objective-C support is insufficient.
  fails_with :gcc

  def install
    ENV.prepend_path "PATH", Formula["gnustep-make"].libexec
    ENV["GNUSTEP_MAKEFILES"] = if OS.mac?
      Formula["gnustep-make"].opt_prefix/"Library/GNUstep/Makefiles"
    else
      Formula["gnustep-make"].share/"GNUstep/Makefiles"
    end

    if OS.mac?
      ENV["ICU_CFLAGS"] = "-I#{MacOS.sdk_path}/usr/include"
      ENV["ICU_LIBS"] = "-L#{MacOS.sdk_path}/usr/lib -licucore"
    end

    # Don't let gnustep-base try to install its makefiles in cellar of gnustep-make.
    inreplace "Makefile.postamble", "$(DESTDIR)$(GNUSTEP_MAKEFILES)", share/"GNUstep/Makefiles"

    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install",
      "GNUSTEP_HEADERS=#{include}",
      "GNUSTEP_LIBRARY=#{share}",
      "GNUSTEP_LOCAL_DOC_MAN=#{man}",
      "GNUSTEP_LOCAL_LIBRARIES=#{lib}",
      "GNUSTEP_LOCAL_TOOLS=#{bin}"
  end

  test do
    (testpath/"test.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <test>
        <text>I'm an XML document.</text>
      </test>
    EOS

    assert_match "Validation failed: no DTD found", shell_output("#{bin}/xmlparse test.xml 2>&1")
  end
end
