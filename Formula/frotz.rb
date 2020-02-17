class Frotz < Formula
  desc "Infocom-style interactive fiction player"
  homepage "https://661.org/proj/if/frotz/"
  url "https://gitlab.com/DavidGriffith/frotz/-/archive/2.51/frotz-2.51.tar.gz"
  sha256 "7916f17061e845e4fa5047c841306c4be2614e9c941753f9739c5d39c7e9f05b"
  head "https://gitlab.com/DavidGriffith/frotz.git"

  bottle do
    sha256 "db1857e58aa0186b418a41426a65ebc047bbda6ed3c29cd8d79ac9b52bde4823" => :catalina
    sha256 "b08e671b1146e1670a25e035b8c69cafc6d21d32700ef9e5e9c3ddaefa3b1ba7" => :mojave
    sha256 "c529875e350b14e50ff06777fca8b5455fe18f20a3ab9efc51929f5358a1d501" => :high_sierra
  end

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "MANDIR", man
      s.change_make_var! "SYSCONFDIR", etc
      s.change_make_var! "SOUND_TYPE", "none"
    end

    system "make", "frotz"
    system "make", "install"
  end

  test do
    assert_match "FROTZ", shell_output("#{bin}/frotz --version").strip
  end
end
