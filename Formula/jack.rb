# This now builds a version of JACKv1 which matches the current API
# for JACKv2. JACKv2 is not buildable on a number of macOS
# distributions, and the JACK team instead suggests installation of
# JACKOSX, a pre-built binary form for which the source is not available.
# If you require JACKv2, you should use that. Otherwise, this formula should
# operate fine.
# Please see https://github.com/Homebrew/homebrew/pull/22043 for more info
class Jack < Formula
  desc "Audio Connection Kit"
  homepage "https://jackaudio.org/"
  # pull from git tag to get submodules
  url "https://github.com/jackaudio/jack1.git",
      tag:      "0.125.0",
      revision: "f5e00e485e7aa4c5baa20355b27e3b84a6912790"
  license "GPL-2.0"
  revision 5
  head "https://github.com/jackaudio/jack1.git"

  bottle do
    sha256 "f06b40271bfe65dc21417b614fa485dbe86d0f1567c52edf95d6fb1cd01323bc" => :big_sur
    sha256 "cd99d66f3ddbe0aeaa35474bfeec3994b779f779fd00f9d5773c79bea8eaf248" => :catalina
    sha256 "ffc645c97ccb709f71b50b756e0fc15485b02b12a695e29b03a428f9bf8c53de" => :mojave
    sha256 "883658cd45eb52986b8eeef5b6443c5d6cf90feeded1ed78446a883e6b00fbda" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "libsamplerate"
  depends_on "libsndfile"

  on_linux do
    depends_on "util-linux"
  end

  def install
    sdk = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""

    # Makefile hardcodes Carbon header location
    inreplace Dir["drivers/coreaudio/Makefile.{am,in}"],
      "/System/Library/Frameworks/Carbon.framework/Headers/Carbon.h",
      "#{sdk}/System/Library/Frameworks/Carbon.framework/Headers/Carbon.h"

    # https://github.com/jackaudio/jack1/issues/81
    inreplace "configure.ac", "-mmacosx-version-min=10.4",
                              "-mmacosx-version-min=#{MacOS.version}"

    system "./autogen.sh"
    ENV["LINKFLAGS"] = ENV.ldflags
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  plist_options manual: "jackd -d coreaudio"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{opt_prefix}</string>
        <key>EnvironmentVariables</key>
        <dict>
          <key>PATH</key>
          <string>/usr/bin:/bin:/usr/sbin:/sbin:#{HOMEBREW_PREFIX}/bin</string>
        </dict>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/jackd</string>
          <string>-d</string>
          <string>coreaudio</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jackd --version")
  end
end
