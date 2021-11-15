class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v1.20.tar.gz"
  sha256 "0c667e7de043a67a740be99d3f236a7aa4107ff62c408e7c462f4fe291f045a7"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "96d4b45a5d3fbfa6c90cd29c2364c76737e15ab2d1df8ad0ae55c2e8f996ea62"
    sha256 arm64_big_sur:  "59af1db70a06eb3fc704edf719802fa21a0b9e79437d7ea6aa6c92ae9ca7af47"
    sha256 monterey:       "0f4040485c0c2cd12daaada9b96069776910d16efa0a9440402771f721c0948c"
    sha256 big_sur:        "d8390aa2929c634cf5e5f1e9214cb351c1f5759e99071db52d4369215f7ae298"
    sha256 catalina:       "0429d88c751ed012adc9665b1468b7977bbade99d5849342723eb5c70759f57a"
    sha256 mojave:         "824307090453ebfcbc755ac4fba653fc0bc00de2d78013991063db926065abcb"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "sdl2"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v1.20/scrcpy-server-v1.20"
    sha256 "b20aee4951f99b060c4a44000ba94de973f9604758ef62beb253b371aad3df34"
  end

  def install
    r = resource("prebuilt-server")
    r.fetch
    cp r.cached_download, buildpath/"prebuilt-server.jar"

    mkdir "build" do
      system "meson", *std_meson_args,
                      "-Dprebuilt_server=#{buildpath}/prebuilt-server.jar",
                      ".."

      system "ninja", "install"
    end
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    fakeadb = (testpath/"fakeadb.sh")

    # When running, scrcpy calls adb three times:
    #  - adb push ... (to push scrcpy-server.jar)
    #  - adb reverse ... tcp:PORT ...
    #  - adb shell ...
    # However, exiting on $1 = shell didn't work properly, so instead
    # fakeadb exits on $1 = reverse

    fakeadb.write <<~EOS
      #!/bin/sh
      echo $@ >> #{testpath/"fakeadb.log"}

      if [ "$1" = "reverse" ]; then
        exit 42
      fi
    EOS

    fakeadb.chmod 0755
    ENV["ADB"] = fakeadb

    # It's expected to fail after adb reverse step because fakeadb exits
    # with code 42
    out = shell_output("#{bin}/scrcpy -p 1337 2>&1", 1)
    assert_match(/ 42/, out)

    log_content = File.read(testpath/"fakeadb.log")

    # Check that it used port we've specified
    assert_match(/tcp:1337/, log_content)

    # Check that it tried to push something from its prefix
    assert_match(/push #{prefix}/, log_content)
  end
end
