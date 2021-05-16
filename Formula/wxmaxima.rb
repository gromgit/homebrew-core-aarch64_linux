class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-21.05.0.tar.gz"
  sha256 "4d42f4c5e76dbea2c37c74a6d5acc066f01fdf61cdeed1668c500b8eaf9ed48b"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    sha256 arm64_big_sur: "75262cf9da74283edf3a0a7034274962620a905021b31dc79943b0acf34fc8b8"
    sha256 big_sur:       "ab6f8289d178a3d475971125af1c2b3870c0afae67f8dd51b36caaa4c7079ac4"
    sha256 catalina:      "348e400e15d5783a498c77d522deaca62d51cd0f4daf9177269e29aa59528c7f"
    sha256 mojave:        "d758f8d0622d132e39ad66bf05d4128769d44f4a4368c3b3adcb033899f506b8"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "ninja" => :build
  depends_on "maxima"
  depends_on "wxmac"

  def install
    mkdir "build-wxm" do
      system "cmake", "..", "-GNinja", *std_cmake_args
      system "ninja"
      system "ninja", "install"

      on_macos do
        prefix.install "src/wxMaxima.app"
      end
    end

    bash_completion.install "data/wxmaxima"

    on_macos do
      bin.write_exec_script "#{prefix}/wxMaxima.app/Contents/MacOS/wxmaxima"
    end
  end

  def caveats
    <<~EOS
      When you start wxMaxima the first time, set the path to Maxima
      (e.g. #{HOMEBREW_PREFIX}/bin/maxima) in the Preferences.

      Enable gnuplot functionality by setting the following variables
      in ~/.maxima/maxima-init.mac:
        gnuplot_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
        draw_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
    EOS
  end

  test do
    on_linux do
      # Error: Unable to initialize GTK+, is DISPLAY set properly
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    assert_match "algebra", shell_output("#{bin}/wxmaxima --help 2>&1")
  end
end
