class Unifdef < Formula
  desc "Selectively process conditional C preprocessor directives"
  homepage "http://dotat.at/prog/unifdef/"
  url "http://dotat.at/prog/unifdef/unifdef-2.11.tar.gz"
  sha256 "e8483c05857a10cf2d5e45b9e8af867d95991fab0f9d3d8984840b810e132d98"
  head "https://github.com/fanf2/unifdef.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7654046a27a2385f120430203bdba11a88639a86fd0cddcfa93ab1c9d9fb752" => :el_capitan
    sha256 "8c4270c42765d2c8f67e8b292ff18004f85102d3c3dc71d4fcf28264ffa6c10d" => :yosemite
    sha256 "75b272ac80122e94ac9f4adecf94c1358861be52869708fe846cc9ef541214d1" => :mavericks
  end

  keg_only :provided_by_osx,
    "The unifdef provided by Xcode cannot compile gevent."

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    pipe_output("#{bin}/unifdef", "echo ''")
  end
end
