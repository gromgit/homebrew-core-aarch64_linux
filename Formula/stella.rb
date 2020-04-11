class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.1.1/stella-6.1.1-src.tar.xz"
  sha256 "ddf53bb782c63c97c4e5d0fefa9eb256c62e0d5a328c78cc18f06eea45ba7369"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    cellar :any
    sha256 "4f90b83facca10dce68f6f09e29a16bc765764f952b305bd97b1c42e1654a096" => :catalina
    sha256 "dd7e8ec56cb7e6ac0e712233536cd8d96788edf01982ce3fb0df688047787009" => :mojave
    sha256 "5229fa4a132849c59203e017f22ae8f2465ecbf3e38e9965ff7ae640f0e57247" => :high_sierra
  end

  depends_on :xcode => :build
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "zlib"

  def install
    sdl2 = Formula["sdl2"]
    libpng = Formula["libpng"]
    cd "src/macos" do
      inreplace "stella.xcodeproj/project.pbxproj" do |s|
        s.gsub! %r{(\w{24} \/\* SDL2\.framework)}, '//\1'
        s.gsub! %r{(\w{24} \/\* png)}, '//\1'
        s.gsub! /(HEADER_SEARCH_PATHS) = \(/,
                "\\1 = (#{sdl2.opt_include}/SDL2, #{libpng.opt_include},"
        s.gsub! /(LIBRARY_SEARCH_PATHS) = ("\$\(LIBRARY_SEARCH_PATHS\)");/,
                "\\1 = (#{sdl2.opt_lib}, #{libpng.opt_lib}, \\2);"
        s.gsub! /(OTHER_LDFLAGS) = "((-\w+)*)"/, '\1 = "-lSDL2 -lpng \2"'
      end
      xcodebuild "SYMROOT=build"
      prefix.install "build/Release/Stella.app"
      bin.write_exec_script "#{prefix}/Stella.app/Contents/MacOS/Stella"
    end
  end

  test do
    assert_match /Stella version #{version}/, shell_output("#{bin}/Stella -help").strip
  end
end
