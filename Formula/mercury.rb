class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-20.06.1.tar.gz"
  sha256 "ef093ae81424c4f3fe696eff9aefb5fb66899e11bb17ae0326adfb70d09c1c1f"
  license all_of: ["GPL-2.0-only", "LGPL-2.0-only", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any, big_sur:     "2b02e97a19000e9c576fdd5c48b29300e210b9464fff7a0b7b68879555b9723b"
    sha256 cellar: :any, catalina:    "ede7304ce96165ca6382118eacb3997e0732b875db721640002d203db9e66346"
    sha256 cellar: :any, mojave:      "ac95cc73104a5621d7a561ae9957561206541633bff5adaf22ed36e21517add1"
    sha256 cellar: :any, high_sierra: "60240308ebcc05ca33a4d40a787745cd4f60b445c9d94302505253bfd4697f6f"
  end

  depends_on "openjdk"

  uses_from_macos "flex"

  def install
    system "./configure", "--prefix=#{prefix}",
            "--mandir=#{man}",
            "--infodir=#{info}",
            "mercury_cv_is_littleender=yes" # Fix broken endianness detection

    system "make", "install", "PARALLEL=-j"

    # Remove batch files for windows.
    rm Dir.glob("#{bin}/*.bat")
  end

  test do
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.m"
    path.write <<~EOS
      :- module hello.
      :- interface.
      :- import_module io.
      :- pred main(io::di, io::uo) is det.
      :- implementation.
      main(IOState_in, IOState_out) :-
          io.write_string("#{test_string}", IOState_in, IOState_out).
    EOS

    system "#{bin}/mmc", "-o", "hello_c", "hello"
    assert_predicate testpath/"hello_c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello_c")

    system "#{bin}/mmc", "--grade", "java", "hello"
    assert_predicate testpath/"hello", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
