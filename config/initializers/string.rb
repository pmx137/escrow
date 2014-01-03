#encoding: utf-8
class String
  #require 'iconv'
    #require 'encoding/character/utf-8'
    #require 'unicode'
  require 'shellwords'

  def pl_downcase
    self.mb_chars.downcase.to_s
  end

  def pl_ucwords
    string = []
    self.split(/\s+|-/).each { |word| string << word.mb_chars.capitalize.to_s }
    string.join(' ')
  end

  def pl_upcase
    self.mb_chars.upcase.to_s
  end

  def shellescape
    Shellwords.shellescape self
  end

  def to_ascii
    # split in muti-byte aware fashion and translate characters over 127
    # and dropping characters not in the translation hash
    self.scan(/./).collect { |c| (c[0].ord <= 127) ? c : translation_hash[c] }.join
  end

  def to_url_format
    url_format = self.to_ascii
    url_format = url_format.gsub(/[^A-Za-z0-9]/, '-') # all non-word
    url_format = url_format.gsub(/\-\-/, '-') # -- -> -
    url_format.downcase!
    url_format
  end

  def strip_tags
    self.gsub(%r{</?[^>]+?>}, '')
  end

  protected
  def translation_hash
    @@translation_hash ||= setup_translation_hash
  end

  def setup_translation_hash
    accented_chars = "ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝàáâãäåçèéêëìíîïñòóôõöøùúûüýĄĆĘŁŃÓŚŻŹąćęłńóśżź".scan /./
    unaccented_chars = "AAAAAACEEEEIIIIDNOOOOOxOUUUUYaaaaaaceeeeiiiinoooooouuuuyACELNOSZZacelnoszz".split('')
    russian_accented_chars = %w{щ э ю я ч ш х й ж ё а б в г д е з и к л м н о п р с т у ф ц ы ъ ь}
    russian_unaccented_chars = %w{shh eh ju ja ch sh kh jj zh jo a b v g d e z i k l m n o p r s t u f c y } + ["", ""]
    accented_chars += russian_accented_chars
    unaccented_chars += russian_unaccented_chars

    translation_hash = {}
    accented_chars.each_with_index { |char, idx| translation_hash[char] = unaccented_chars[idx] }
    translation_hash["Æ"] = 'AE'
    translation_hash["æ"] = 'ae'
    translation_hash
  end
end
