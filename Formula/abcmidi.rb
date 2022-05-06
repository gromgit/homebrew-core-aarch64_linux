class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.05.05.zip"
  sha256 "ec22123b90c5ec29a54b91e4d6651c056f1ff5c168fff3256cafd3205e32ef4f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93ad05d2d58487a954e5fe1fa281a5b4dbf0da620c9eed72013a7e18020c5a99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e74491ed5179e0e8a131347b257efe28b6dfec6f296045cb60ec54301212c23"
    sha256 cellar: :any_skip_relocation, monterey:       "4c304e1312fa95eb8408d37b5e58b17273d0f9660ad3732893e08473a68ac517"
    sha256 cellar: :any_skip_relocation, big_sur:        "cea96c7eeed87a6091957d532b9c8891a63e07d9fa4011c623575c416fbe490f"
    sha256 cellar: :any_skip_relocation, catalina:       "283c16107fe744d90b47ccc69853fde9a9c7120ee9bacd5c0a5c84effed166c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dde1bfcf2f5cd8019f5334dec86d97e7c4c59199947b7b56ba508f22ddcf95ed"
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
