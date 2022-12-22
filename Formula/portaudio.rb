class Portaudio < Formula
  desc "Cross-platform library for audio I/O"
  homepage "http://www.portaudio.com"
  url "http://files.portaudio.com/archives/pa_stable_v190700_20210406.tgz"
  version "19.7.0"
  sha256 "47efbf42c77c19a05d22e627d42873e991ec0c1357219c0d74ce6a2948cb2def"
  license "MIT"
  version_scheme 1
  head "https://github.com/PortAudio/portaudio.git", branch: "master"

  livecheck do
    url "http://files.portaudio.com/download.html"
    regex(/href=.*?pa[._-]stable[._-]v?(\d+)(?:[._-]\d+)?\.t/i)
    strategy :page_match do |page, regex|
      # Modify filename version (190700) to match formula version (19.7.0)
      page.scan(regex).map { |match| match&.first&.scan(/\d{2}/)&.map(&:to_i)&.join(".") }
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/portaudio"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a47d92d6fa525f10f27786f982475f1aacaf742849262c3324ede66598721cec"
  end

  depends_on "pkg-config" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
  end

  def install
    system "./configure", *std_configure_args,
                          "--enable-mac-universal=no",
                          "--enable-cxx"
    system "make", "install"

    # Need 'pa_mac_core.h' to compile PyAudio
    include.install "include/pa_mac_core.h" if OS.mac?
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "portaudio.h"

      int main(){
        printf("%s",Pa_GetVersionInfo()->versionText);
      }
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include "portaudiocpp/System.hxx"

      int main(){
        std::cout << portaudio::System::versionText();
      }
    EOS

    system ENV.cc, testpath/"test.c", "-I#{include}", "-L#{lib}", "-lportaudio", "-o", "test"
    system ENV.cxx, testpath/"test.cpp", "-I#{include}", "-L#{lib}", "-lportaudiocpp", "-o", "test_cpp"
    assert_match stable.version.to_s, shell_output(testpath/"test")
    assert_match stable.version.to_s, shell_output(testpath/"test_cpp")
  end
end
