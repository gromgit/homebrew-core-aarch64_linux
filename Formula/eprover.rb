class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "https://eprover.org/"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_2.5/E.tgz"
  sha256 "3a72cb5bcf24899134c84cb6c797c699d8d7ddfad0de7b5b654581bb17b3c814"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc6c6e87ee95f0cfd0f0f0a838fd40bf2f9613f7e78b1a5c9f0b33bc7ca7b094" => :catalina
    sha256 "fd14ba20a1ed8799a668e6f521ddbd8c1fac8ff43ac1f14bb6c9346ee7980cf3" => :mojave
    sha256 "5db8b8088c46bde8355a4742572d63db7ccea5885b37c401e05579762271559f" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--man-prefix=#{man1}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/eprover", "--help"
  end
end
