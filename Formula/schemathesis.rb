class Schemathesis < Formula
  include Language::Python::Virtualenv

  desc "Testing tool for web applications with specs"
  homepage "https://schemathesis.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/23/d8/95214ec73fae3610607744fe4e1fd162112cc608ff2d75544a28d44bdacd/schemathesis-3.17.2.tar.gz"
  sha256 "466842d680f3b59dd9cbd406cb6e19516193bd36b4c256987c306a58bfee6a5e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f282b8a7404fcd6592a0827feb33f7abf765110f97c32186253d84600457acf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3075c6296d59dae257609e77be7e5ea1f7e74fe63b23486e482560c58492641"
    sha256 cellar: :any_skip_relocation, monterey:       "78cb9f6d2e247647b1bf6f180eb4a1e62e079e0d4ba8f83f34a1abe65cf1ec39"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea9bacebfb14789bb40cadd4b509a12e525d6ea2e00d9c2fe27cf6264be02d7e"
    sha256 cellar: :any_skip_relocation, catalina:       "1b29436dce4cf6c7b921ee8d0f9bf6ee26d58f66237c31712338b0bde20811dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be8f25c6937a70d7845862fdc0d15d206fceea025ce95fa42b1b4dcf6a26cef1"
  end

  depends_on "flit" => :build
  depends_on "poetry" => :build
  depends_on "jsonschema"
  depends_on "python-typing-extensions"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  resource "hypothesis" do
    url "https://files.pythonhosted.org/packages/da/f6/53077bf0a5745fc45e32dc86882b945d16d26f994c884fe86d793f5e4d7f/hypothesis-6.49.1.tar.gz"
    sha256 "0310d446fb87415e31798e8267288acc22f0be4a0530128a3a694190fcc43e5b"
  end

  resource "hypothesis_jsonschema" do
    url "https://files.pythonhosted.org/packages/81/e0/c2802558d47e179e234f45c5d9dc39ff45d30d28692839a10be391d892fd/hypothesis-jsonschema-0.22.0.tar.gz"
    sha256 "359504080a422924a77263789a00c4995b061991558ff6a8243949f94a4d74fc"
  end

  resource "hypothesis_graphql" do
    url "https://files.pythonhosted.org/packages/d7/8e/e59c7ffc179e0e5e8f47ff9ca393cef26aa83dc2aa5c25f40d2edc477d5e/hypothesis-graphql-0.9.1.tar.gz"
    sha256 "e766bc21731e1183947e67f2d38c7a156a3904c7403b6bae628d26913553334a"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/4e/1f/34657c6ac56f3c58df650ba41f8ffb2620281ead8e11bcdc7db63cf72a78/pytest-7.1.2.tar.gz"
    sha256 "a06a0425453864a270bc45e71f783330a7428defb4230fb5e6a731fde06ecd45"
  end

  resource "pytest-subtests" do
    url "https://files.pythonhosted.org/packages/2f/7a/1af817d053ad4989a8b56528a4eed9cfa64e865624d0408d729d980ab658/pytest-subtests-0.8.0.tar.gz"
    sha256 "46eb376022e926950816ccc23502de3277adcc1396652ddb3328ce0289052c4d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/32/19/a92cdbd9fb795928dfca1031278ae8a7f051e78a2c057c224ad2d4cdd95e/Werkzeug-2.2.1.tar.gz"
    sha256 "4d7013ef96fd197d1cdeb03e066c6c5a491ccb44758a5b2b91137319383e5a5a"
  end

  # only doing this because junit-xml source is not available in PyPI for v1.9
  resource "junit-xml" do
    url "https://github.com/kyrus/python-junit-xml.git",
        revision: "4bd08a272f059998cedf9b7779f944d49eba13a6"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/b7/9b/dc9fa4c05a8aceb7abbf057b1279f0007ce8ab42c9b8f31a9c71981955bc/starlette-0.20.4.tar.gz"
    sha256 "42fcf3122f998fefce3e2c5ad7e5edbf0f02cf685d646a83a08d404726af5084"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/d6/04/255c68974ec47fa754564c4abba8f61f9ed68b869bbbb854198d6259c4f7/yarl-1.8.1.tar.gz"
    sha256 "af887845b8c2e060eb5605ff72b6f2dd2aab7a761379373fd89d314f4752abbf"
  end

  resource "curlify" do
    url "https://files.pythonhosted.org/packages/fa/2c/9254b2294d0250291560d78e16e5cd764b8e2caa75d4cad1e8ae9d73899d/curlify-2.2.1.tar.gz"
    sha256 "0d3f02e7235faf952de8ef45ef469845196d30632d5838bcd5aee217726ddd6d"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/94/e0/2f58a7e00e28cd57f8239bd8d16963c2810142af58028cf5b0681ed9fdfd/exceptiongroup-1.0.0rc8.tar.gz"
    sha256 "6990c24f06b8d33c8065cfe43e5e8a4bfa384e0358be036af9cc60b6321bd11a"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/61/9e/798c1cfc5b03e98f068a793c2d2f1fd94f76ba50521f3812ff1a4e3c29d2/graphql-core-3.2.1.tar.gz"
    sha256 "9d1bf141427b7d54be944587c8349df791ce60ade2e3cccaf9c56368c133c201"

    # latest version of poetry requires description to be only one line
    patch do
      url "https://github.com/graphql-python/graphql-core/commit/78f32d0e45c149bf894202b4da7c16216d91e2e5.patch?full_index=1"
      sha256 "ef0128ae16121308856e66efa68a0ce1a9e35191e4dabae5cea9e9c43c45997f"
    end
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/67/c4/fd50bbb2fb72532a4b778562e28ba581da15067cfb2537dbd3a2e64689c1/anyio-3.6.1.tar.gz"
    sha256 "413adf95f93886e442aea925f3ee43baa5a765a64a0f52c6081894f9992fdd0b"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/fa/a7/71c253cdb8a1528802bac7503bf82fe674367e4055b09c28846fdfa4ab90/multidict-6.0.2.tar.gz"
    sha256 "5ff3bd75f38e4c43f1f470f2df7a4d430b821c4ce22be384e1459cb57d6bb013"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "charset_normalizer" do
    url "https://files.pythonhosted.org/packages/93/1d/d9392056df6670ae2a29fcb04cfa5cee9f6fbde7311a1bb511d4115e9b7a/charset-normalizer-2.1.0.tar.gz"
    sha256 "575e708016ff3a5e3681541cb9d79312c416835686d054a23accb873b254f413"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/6d/d5/e8258b334c9eb8eb78e31be92ea0d5da83ddd9385dc967dd92737604d239/urllib3-1.26.11.tar.gz"
    sha256 "ea6e8fb210b19d950fab93b60c9009226c63a28808bc8386e05301e25883ac0a"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/23/a2/97899f6bd0e873fed3a7e67ae8d3a08b21799430fb4da15cfedf10d6e2c2/iniconfig-1.1.1.tar.gz"
    sha256 "bc3af051d7d14b2ee5ef9969666def0cd1a000e121eaea580d4a313df4b37f32"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/98/ff/fec109ceb715d2a6b4c4a85a61af3b40c723a961e8828319fbcb15b868dc/py-1.11.0.tar.gz"
    sha256 "51c75c4126074b472f746a24399ad32f6053d1b34b68d2fa41e558e6f4a98719"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a6/ae/44ed7978bcb1f6337a3e2bef19c941de750d73243fc9389140d62853b686/sniffio-1.2.0.tar.gz"
    sha256 "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/3b/22/53182ff2977aa653cb61f30592cbfb5d3e0764368c8eaa8ec096e6899b7a/backoff-2.1.2.tar.gz"
    sha256 "407f1bc0f22723648a8880821b935ce5df8475cf04f7b6b5017ae264d30f6069"
  end

  def install
    venv = virtualenv_create(libexec, "python3.10")

    # Install hypothesis_graphql and graphql-core using brewed poetry to avoid build dependency on Rust.
    resource("hypothesis_graphql").stage do
      system Formula["poetry"].opt_bin/"poetry", "build", "--format", "wheel", "--verbose", "--no-interaction"
      venv.pip_install_and_link Pathname.glob("dist/hypothesis_graphql-*.whl").first
    end

    resource("graphql-core").stage do
      system Formula["poetry"].opt_bin/"poetry", "build", "--format", "wheel", "--verbose", "--no-interaction"
      venv.pip_install_and_link Pathname.glob("dist/graphql_core-*.whl").first
    end

    # Install exceptiongroup using flit, to avoid re-installing it
    resource("exceptiongroup").stage do
      system Formula["flit"].opt_bin/"flit", "build", "--format", "wheel"
      venv.pip_install_and_link Pathname.glob("dist/exceptiongroup-*.whl").first
    end

    already_installed = %w[hypothesis_graphql graphql-core exceptiongroup]
    venv.pip_install resources.reject { |r| already_installed.include?(r.name) }
    venv.pip_install_and_link buildpath

    # we depend on jsonschema, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.10")
    jsonschema = Formula["jsonschema"].opt_libexec
    (libexec/site_packages/"homebrew-jsonschema.pth").write jsonschema/site_packages
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "openapi": "3.0.3",
        "paths": {}
      }
    EOS
    output = shell_output("#{bin}/st run ./example.json --dry-run")
    assert_match "Schemathesis test session starts", output
    assert_match "Specification version: Open API 3.0.3", output
    assert_match "No checks were performed.", output
  end
end
