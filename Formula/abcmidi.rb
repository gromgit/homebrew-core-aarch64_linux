class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2021.12.12.zip"
  sha256 "a50cad5fcdfc0e4a0a2df27b1e983bc0f6776e16b2d503d190622176318695e3"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "631e0c3d9d4a9448bf35896b0db8098e1151b6e6c5aed75ec95288ce22945252"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a56864cd269a2b4dd420eb6b8e9fd537922e294dcffd36bca851ab9abf9fde1a"
    sha256 cellar: :any_skip_relocation, monterey:       "24adcf54645a966b7786c65e09f0f917de101b6f59bf2981dee60ecb03bec748"
    sha256 cellar: :any_skip_relocation, big_sur:        "62ffd47508529df6c7418e40b855031d4bc104108557fbdc0f81a261aa8e846c"
    sha256 cellar: :any_skip_relocation, catalina:       "a406f8205d94fea9e6983f7a3cdc1cd882073a3af14015da26961293e406b3ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d96edeffde21c8be87d8f2ae01720610d8a8bff0d284360dd9db7dfedc556201"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"balk.abc").write <<~EOS
      X: 1
      T: Abdala
      F: https://www.youtube.com/watch?v=YMf8yXaQDiQ
      L: 1/8
      M: 2/4
      K:Cm
      Q:1/4=180
      %%MIDI bassprog 32 % 32 Acoustic Bass
      %%MIDI program 23 % 23 Tango Accordian
      %%MIDI bassvol 69
      %%MIDI gchord fzfz
      |:"G"FDEC|D2C=B,|C2=B,2 |C2D2   |\
        FDEC   |D2C=B,|C2=B,2 |A,2G,2 :|
      |:=B,CDE |D2C=B,|C2=B,2 |C2D2   |\
        =B,CDE |D2C=B,|C2=B,2 |A,2G,2 :|
      |:C2=B,2 |A,2G,2| C2=B,2|A,2G,2 :|
    EOS

    system "#{bin}/abc2midi", (testpath/"balk.abc")
  end
end
