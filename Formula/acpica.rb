class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20200528.tar.gz"
  sha256 "e69f81c6924c8d30f9b9005bb002307f07b5a1538e13c909bea2f8a44e0d8610"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd77c7ab262dccd3cb56bb5685ef94aabb63a0f3bffb1834504a12fb910bf0ed" => :catalina
    sha256 "d5be4c0ca5c62d26063618cd358b552f13bde291c68792016b8d3ec3e74579ef" => :mojave
    sha256 "b6b6ae7b98a9450ac248d85bee082743f749a95320550028198af6f2c6e0681f" => :high_sierra
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "m4" => :build

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/acpihelp", "-u"
  end
end
